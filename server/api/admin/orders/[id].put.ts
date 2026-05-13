import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const id = getRouterParam(event, 'id')
  const { orderStatus } = await readBody(event)

  const { data, error } = await client
    .from('orders')
    .update({ orderStatus, updatedAt: new Date().toISOString() })
    .eq('id', Number(id))
    .select()
    .single()

  if (error) throw createError({ statusCode: 400, statusMessage: error.message })
  return { order: data }
})
