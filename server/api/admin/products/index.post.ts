import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const body = await readBody(event)

  const slug = body.slug || body.name?.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '')

  const { data, error } = await client
    .from('products')
    .insert({ ...body, slug })
    .select()
    .single()

  if (error) throw createError({ statusCode: 400, statusMessage: error.message })
  return { product: data }
})
