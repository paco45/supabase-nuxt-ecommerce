import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const id = getRouterParam(event, 'id')

  const { data, error } = await client
    .from('orders')
    .select('*, addresses(*), orderItems(*, products(id, name, primaryImage, unitPrice))')
    .eq('id', Number(id))
    .single()

  if (error) throw createError({ statusCode: 404, statusMessage: 'Orden no encontrada' })
  return { order: data }
})
