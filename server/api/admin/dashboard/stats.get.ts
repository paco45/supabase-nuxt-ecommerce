import { requireAdmin } from '~/server/utils/adminAuth'

export default defineEventHandler(async (event) => {
  const { client } = await requireAdmin(event)

  const [
    { count: totalProducts },
    { count: totalOrders },
    { data: revenueData },
    { data: lowStock },
    { data: recentOrders },
    { data: ordersByStatus },
  ] = await Promise.all([
    client.from('products').select('*', { count: 'exact', head: true }),
    client.from('orders').select('*', { count: 'exact', head: true }),
    client.from('orderItems').select('price, quantity'),
    client.from('products').select('id, name, primaryImage, stockQuantity').lt('stockQuantity', 5).order('stockQuantity'),
    client.from('orders')
      .select('id, orderStatus, createdAt, userId')
      .order('createdAt', { ascending: false })
      .limit(5),
    client.from('orders').select('orderStatus'),
  ])

  const totalRevenue = revenueData?.reduce((sum, item) => sum + (item.price ?? 0) * (item.quantity ?? 0), 0) ?? 0

  const statusCount = (ordersByStatus ?? []).reduce((acc: Record<string, number>, o) => {
    const s = o.orderStatus ?? 'Pending'
    acc[s] = (acc[s] ?? 0) + 1
    return acc
  }, {})

  return {
    totalProducts: totalProducts ?? 0,
    totalOrders: totalOrders ?? 0,
    totalRevenue,
    lowStockCount: (lowStock ?? []).length,
    lowStockProducts: lowStock ?? [],
    recentOrders: recentOrders ?? [],
    ordersByStatus: statusCount,
  }
})
