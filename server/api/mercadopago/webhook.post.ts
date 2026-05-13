import { MercadoPagoConfig, Payment } from 'mercadopago'
import { serverSupabaseServiceRole } from '#supabase/server'

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig()
  const body = await readBody(event)
  const query = getQuery(event)

  // MercadoPago envía el webhook de dos formas:
  // 1. IPN legacy: query params ?id=xxx&topic=payment
  // 2. Notifications v2: body { type, data: { id } }
  const paymentId = body?.data?.id ?? query.id
  const topic = body?.type ?? query.topic

  if (!paymentId || topic !== 'payment') {
    return { received: true }
  }

  try {
    const mp = new MercadoPagoConfig({ accessToken: config.mercadopagoAccessToken })
    const paymentClient = new Payment(mp)
    const payment = await paymentClient.get({ id: String(paymentId) })

    const orderId = payment.external_reference
    if (!orderId) return { received: true }

    const client = serverSupabaseServiceRole(event)

    // Mapear estado MP → estado de la orden
    const statusMap: Record<string, string> = {
      approved: 'Confirmed',
      pending: 'Pending',
      in_process: 'Pending',
      rejected: 'Cancelled',
      cancelled: 'Cancelled',
      refunded: 'Cancelled',
    }

    const orderStatus = statusMap[payment.status ?? ''] ?? 'Pending'

    await client
      .from('orders')
      .update({
        orderStatus,
        mercadopagoStatus: payment.status,
        mercadopagoId: String(paymentId),
        paymentMethod: payment.payment_type_id ?? null,
        updatedAt: new Date().toISOString(),
      })
      .eq('id', Number(orderId))

    // Si el pago fue aprobado, descontar stock
    if (payment.status === 'approved') {
      const { data: orderItems } = await client
        .from('orderItems')
        .select('productId, quantity')
        .eq('orderId', Number(orderId))

      for (const item of orderItems ?? []) {
        await client.rpc('decrement_stock', {
          p_product_id: item.productId,
          p_quantity: item.quantity,
        })
      }
    }
  } catch (err) {
    console.error('[MP Webhook] Error:', err)
  }

  return { received: true }
})
