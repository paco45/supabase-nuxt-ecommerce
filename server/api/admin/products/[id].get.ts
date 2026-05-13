import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)
  const id = getRouterParam(event, 'id')

  const { data, error } = await client
    .from('products')
    .select('*, categories(id, name)')
    .eq('id', Number(id))
    .single()

  if (error) throw createError({ statusCode: 404, statusMessage: 'Producto no encontrado' })
  return { product: data }
})
