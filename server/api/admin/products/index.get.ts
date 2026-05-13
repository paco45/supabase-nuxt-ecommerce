import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const query = getQuery(event)

  const page = Number(query.page ?? 1)
  const limit = Number(query.limit ?? 20)
  const search = query.search as string | undefined
  const from = (page - 1) * limit

  let q = client
    .from('products')
    .select('id, name, slug, unitPrice, currency, stockQuantity, inStock, primaryImage, skincareCategory, isFeatured, createdAt', { count: 'exact' })
    .order('createdAt', { ascending: false })
    .range(from, from + limit - 1)

  if (search) q = q.ilike('name', `%${search}%`)

  const { data, error, count } = await q
  if (error) throw createError({ statusCode: 400, statusMessage: error.message })

  return { products: data, total: count ?? 0, page, limit }
})
