import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const id = getRouterParam(event, 'id')

  const { error } = await client.from('categories').delete().eq('id', Number(id))
  if (error) throw createError({ statusCode: 400, statusMessage: error.message })
  return { success: true }
})
