<template>
  <div class="space-y-6">
    <!-- Stats cards -->
    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
      <div v-for="stat in stats" :key="stat.label" class="bg-card rounded-xl border border-border p-4">
        <div class="flex items-center justify-between mb-3">
          <span class="text-xs font-medium text-muted-foreground uppercase tracking-wide">{{ stat.label }}</span>
          <div class="w-8 h-8 rounded-lg flex items-center justify-center" :class="stat.iconBg">
            <Icon :name="stat.icon" class="w-4 h-4" :class="stat.iconColor" />
          </div>
        </div>
        <p class="text-2xl font-heading font-semibold">{{ stat.value }}</p>
        <p v-if="stat.sub" class="text-xs text-muted-foreground mt-1">{{ stat.sub }}</p>
      </div>
    </div>

    <div class="grid lg:grid-cols-3 gap-6">
      <!-- Órdenes recientes -->
      <div class="lg:col-span-2 bg-card rounded-xl border border-border">
        <div class="p-4 border-b border-border flex items-center justify-between">
          <h2 class="font-heading font-semibold">Órdenes recientes</h2>
          <NuxtLink to="/admin/ordenes" class="text-xs text-primary hover:underline">Ver todas</NuxtLink>
        </div>
        <div class="divide-y divide-border">
          <div v-if="!dashboardData?.recentOrders?.length" class="p-8 text-center text-muted-foreground text-sm">
            Aún no hay órdenes
          </div>
          <div
            v-for="order in dashboardData?.recentOrders"
            :key="order.id"
            class="flex items-center gap-4 p-4 hover:bg-muted/40 transition-colors cursor-pointer"
            @click="navigateTo(`/admin/ordenes/${order.id}`)"
          >
            <div class="w-9 h-9 rounded-full bg-muted flex items-center justify-center shrink-0">
              <Icon name="lucide:shopping-bag" class="w-4 h-4 text-muted-foreground" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium">Orden #{{ order.id }}</p>
              <p class="text-xs text-muted-foreground">{{ formatDate(order.createdAt) }}</p>
            </div>
            <span class="text-xs px-2 py-1 rounded-full font-medium shrink-0" :class="statusClass(order.orderStatus)">
              {{ order.orderStatus }}
            </span>
          </div>
        </div>
      </div>

      <!-- Stock bajo -->
      <div class="bg-card rounded-xl border border-border">
        <div class="p-4 border-b border-border flex items-center justify-between">
          <h2 class="font-heading font-semibold">Stock bajo</h2>
          <NuxtLink to="/admin/inventario" class="text-xs text-primary hover:underline">Gestionar</NuxtLink>
        </div>
        <div class="divide-y divide-border">
          <div v-if="!dashboardData?.lowStockProducts?.length" class="p-8 text-center text-muted-foreground text-sm">
            Todo el stock está bien
          </div>
          <div
            v-for="product in dashboardData?.lowStockProducts"
            :key="product.id"
            class="flex items-center gap-3 p-3 hover:bg-muted/40 transition-colors"
          >
            <img
              v-if="product.primaryImage"
              :src="product.primaryImage"
              :alt="product.name"
              class="w-9 h-9 rounded-lg object-cover shrink-0 bg-muted"
            />
            <div v-else class="w-9 h-9 rounded-lg bg-muted shrink-0" />
            <div class="flex-1 min-w-0">
              <p class="text-sm font-medium truncate">{{ product.name }}</p>
              <p class="text-xs" :class="product.stockQuantity === 0 ? 'text-destructive font-medium' : 'text-amber-600'">
                {{ product.stockQuantity === 0 ? 'Sin stock' : `${product.stockQuantity} unidades` }}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Órdenes por estado -->
    <div class="bg-card rounded-xl border border-border p-4">
      <h2 class="font-heading font-semibold mb-4">Órdenes por estado</h2>
      <div class="grid grid-cols-3 sm:grid-cols-6 gap-3">
        <div
          v-for="(count, status) in dashboardData?.ordersByStatus"
          :key="status"
          class="text-center p-3 rounded-lg bg-muted/50"
        >
          <p class="text-lg font-heading font-semibold">{{ count }}</p>
          <p class="text-xs text-muted-foreground mt-1">{{ status }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { getDashboardStats } = useAdminServices()
const { data: dashboardData, refresh } = await useAsyncData('admin-stats', getDashboardStats)

const stats = computed(() => [
  {
    label: 'Productos',
    value: dashboardData.value?.totalProducts ?? 0,
    icon: 'lucide:package',
    iconBg: 'bg-blue-50',
    iconColor: 'text-blue-500',
  },
  {
    label: 'Órdenes',
    value: dashboardData.value?.totalOrders ?? 0,
    icon: 'lucide:shopping-bag',
    iconBg: 'bg-primary/10',
    iconColor: 'text-primary',
  },
  {
    label: 'Ingresos',
    value: formatCOP(dashboardData.value?.totalRevenue ?? 0),
    icon: 'lucide:banknote',
    iconBg: 'bg-green-50',
    iconColor: 'text-green-500',
  },
  {
    label: 'Stock bajo',
    value: dashboardData.value?.lowStockCount ?? 0,
    icon: 'lucide:alert-triangle',
    iconBg: 'bg-amber-50',
    iconColor: 'text-amber-500',
    sub: 'productos con menos de 5 unidades',
  },
])

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(value)
}

function formatDate(date: string | null) {
  if (!date) return ''
  return new Intl.DateTimeFormat('es-CO', { day: '2-digit', month: 'short', year: 'numeric' }).format(new Date(date))
}

function statusClass(status: string | null) {
  const map: Record<string, string> = {
    Pending: 'bg-amber-100 text-amber-700',
    Confirmed: 'bg-blue-100 text-blue-700',
    Processed: 'bg-indigo-100 text-indigo-700',
    Shipped: 'bg-purple-100 text-purple-700',
    Delivered: 'bg-green-100 text-green-700',
    Cancelled: 'bg-red-100 text-red-700',
  }
  return map[status ?? ''] ?? 'bg-muted text-muted-foreground'
}
</script>
