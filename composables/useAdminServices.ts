const SKINCARE_CATEGORIES = [
  'Limpiadores', 'Tónicos', 'Sérums', 'Hidratantes',
  'Protección Solar', 'Contorno de Ojos', 'Mascarillas',
  'Exfoliantes', 'Aceites', 'Kits',
] as const

const ORDER_STATUSES = ['Pending', 'Confirmed', 'Processed', 'Shipped', 'Delivered', 'Cancelled'] as const

export type SkincareCategory = typeof SKINCARE_CATEGORIES[number]
export type OrderStatus = typeof ORDER_STATUSES[number]

export const useAdminServices = () => {
  // ── Dashboard ─────────────────────────────────────────────
  async function getDashboardStats() {
    return $fetch('/api/admin/dashboard/stats')
  }

  // ── Products ──────────────────────────────────────────────
  async function getProducts(params?: { page?: number; search?: string; limit?: number }) {
    return $fetch('/api/admin/products', { query: params })
  }

  async function getProduct(id: number) {
    return $fetch(`/api/admin/products/${id}`)
  }

  async function createProduct(data: Record<string, unknown>) {
    return $fetch('/api/admin/products', { method: 'POST', body: data })
  }

  async function updateProduct(id: number, data: Record<string, unknown>) {
    return $fetch(`/api/admin/products/${id}`, { method: 'PUT', body: data })
  }

  async function deleteProduct(id: number) {
    return $fetch(`/api/admin/products/${id}`, { method: 'DELETE' })
  }

  async function updateStock(id: number, stockQuantity: number) {
    return $fetch(`/api/admin/products/${id}`, { method: 'PUT', body: { stockQuantity } })
  }

  // ── Orders ────────────────────────────────────────────────
  async function getOrders(params?: { page?: number; status?: string; limit?: number }) {
    return $fetch('/api/admin/orders', { query: params })
  }

  async function getOrder(id: number) {
    return $fetch(`/api/admin/orders/${id}`)
  }

  async function updateOrderStatus(id: number, orderStatus: OrderStatus) {
    return $fetch(`/api/admin/orders/${id}`, { method: 'PUT', body: { orderStatus } })
  }

  // ── Categories ────────────────────────────────────────────
  async function getCategories() {
    return $fetch('/api/admin/categories')
  }

  async function createCategory(data: Record<string, unknown>) {
    return $fetch('/api/admin/categories', { method: 'POST', body: data })
  }

  async function updateCategory(id: number, data: Record<string, unknown>) {
    return $fetch(`/api/admin/categories/${id}`, { method: 'PUT', body: data })
  }

  async function deleteCategory(id: number) {
    return $fetch(`/api/admin/categories/${id}`, { method: 'DELETE' })
  }

  return {
    SKINCARE_CATEGORIES,
    ORDER_STATUSES,
    getDashboardStats,
    getProducts,
    getProduct,
    createProduct,
    updateProduct,
    deleteProduct,
    updateStock,
    getOrders,
    getOrder,
    updateOrderStatus,
    getCategories,
    createCategory,
    updateCategory,
    deleteCategory,
  }
}
