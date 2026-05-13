import { MercadoPagoConfig, Preference } from 'mercadopago'
import { serverSupabaseServiceRole, serverSupabaseUser } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const { cartItems, addressId } = body

  // Validar items
  if (!cartItems?.length) {
    throw createError({ statusCode: 400, statusMessage: 'El carrito está vacío' })
  }

  // Usuario (opcional — permite checkout como invitado)
  const user = await serverSupabaseUser(event).catch(() => null)
  const client = serverSupabaseServiceRole(event)

  // 1. Crear orden en DB con estado Pending
  const { data: order, error: orderError } = await client
    .from('orders')
    .insert({
      userId: user?.id ?? null,
      addressId: addressId ?? null,
      orderStatus: 'Pending',
    })
    .select()
    .single()

  if (orderError) {
    throw createError({ statusCode: 500, statusMessage: 'Error al crear la orden' })
  }

  // 2. Insertar items de la orden
  const orderItemsData = cartItems.map((item: any) => ({
    orderId: order.id,
    productId: item.productId,
    price: item.price,
    quantity: item.quantity,
  }))

  await client.from('orderItems').insert(orderItemsData)

  // 3. Crear preferencia en MercadoPago
  const mp = new MercadoPagoConfig({ accessToken: config.mercadopagoAccessToken })
  const preferenceClient = new Preference(mp)

  const baseUrl = process.env.BASE_URL ?? 'http://localhost:3001'

  const items = cartItems.map((item: any) => ({
    id: String(item.productId),
    title: item.name ?? `Producto #${item.productId}`,
    quantity: item.quantity,
    unit_price: Number(item.price),
    currency_id: 'COP',
  }))

  const preference = await preferenceClient.create({
    body: {
      items,
      external_reference: String(order.id),
      back_urls: {
        success: `${baseUrl}/confirm`,
        pending: `${baseUrl}/confirm`,
        failure: `${baseUrl}/checkout`,
      },
      auto_return: 'approved',
      notification_url: `${baseUrl}/api/mercadopago/webhook`,
      statement_descriptor: 'SKINCARE STORE',
      expires: false,
    },
  })

  // 4. Guardar preference_id en la orden
  await client
    .from('orders')
    .update({ mercadopagoId: preference.id })
    .eq('id', order.id)

  return {
    preferenceId: preference.id,
    initPoint: preference.init_point,       // producción
    sandboxInitPoint: preference.sandbox_init_point, // pruebas
    orderId: order.id,
  }
})
