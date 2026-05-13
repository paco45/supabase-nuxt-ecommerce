import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const query = getQuery(event)

  const page = Number(query.page ?? 1)
  const limit = Number(query.limit ?? 20)
  const status = query.status as string | undefined
  const from = (page - 1) * limit

  let q = client
    .from('orders')
    .select('id, orderStatus, mercadopagoStatus, paymentMethod, createdAt, userId, addresses(name, city)', { count: 'exact' })
    .order('createdAt', { ascending: false })
    .range(from, from + limit - 1)

  if (status) q = q.eq('orderStatus', status)

  const { data, error, count } = await q
  if (error) throw createError({ statusCode: 400, statusMessage: error.message })

  return { orders: data, total: count ?? 0, page, limit }
})
