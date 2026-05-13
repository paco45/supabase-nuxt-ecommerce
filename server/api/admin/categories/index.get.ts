import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)

  const { data, error } = await client
    .from('categories')
    .select('*, products(count)')
    .order('id')

  if (error) throw createError({ statusCode: 400, statusMessage: error.message })
  return { categories: data }
})
