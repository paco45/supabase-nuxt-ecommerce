import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const id = getRouterParam(event, 'id')
  const body = await readBody(event)

  const { data, error } = await client
    .from('categories')
    .update(body)
    .eq('id', Number(id))
    .select()
    .single()

  if (error) throw createError({ statusCode: 400, statusMessage: error.message })
  return { category: data }
})
