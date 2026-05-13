<template>
  <div class="space-y-4">
    <!-- Filtros -->
    <div class="flex flex-wrap gap-2">
      <button
        v-for="s in ['Todas', ...ORDER_STATUSES]"
        :key="s"
        class="px-3 py-1.5 rounded-full text-xs font-medium border transition-colors"
        :class="activeStatus === (s === 'Todas' ? '' : s)
          ? 'bg-primary text-primary-foreground border-primary'
          : 'border-border hover:border-primary/50'"
        @click="activeStatus = s === 'Todas' ? '' : s; page = 1; fetchOrders()"
      >{{ s }}</button>
    </div>

    <!-- Tabla -->
    <div class="bg-card rounded-xl border border-border overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-border bg-muted/40">
              <th class="text-left px-4 py-3 font-medium text-muted-foreground">#</th>
              <th class="text-left px-4 py-3 font-medium text-muted-foreground hidden sm:table-cell">Cliente</th>
              <th class="text-left px-4 py-3 font-medium text-muted-foreground hidden md:table-cell">Ciudad</th>
              <th class="text-center px-4 py-3 font-medium text-muted-foreground">Estado</th>
              <th class="text-left px-4 py-3 font-medium text-muted-foreground hidden lg:table-cell">Fecha</th>
              <th class="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-if="pending" v-for="i in 6" :key="i" class="animate-pulse">
              <td colspan="6" class="px-4 py-3"><div class="h-4 bg-muted rounded w-full" /></td>
            </tr>
            <tr v-else-if="!orders?.length">
              <td colspan="6" class="px-4 py-12 text-center text-muted-foreground">No hay órdenes aún.</td>
            </tr>
            <tr
              v-for="order in orders"
              :key="order.id"
              class="hover:bg-muted/30 transition-colors cursor-pointer"
              @click="navigateTo(`/admin/ordenes/${order.id}`)"
            >
              <td class="px-4 py-3 font-medium">#{{ order.id }}</td>
              <td class="px-4 py-3 text-muted-foreground hidden sm:table-cell truncate max-w-[140px]">
                {{ order.addresses?.name ?? order.userId?.slice(0, 8) + '...' }}
              </td>
              <td class="px-4 py-3 text-muted-foreground hidden md:table-cell">{{ order.addresses?.city ?? '—' }}</td>
              <td class="px-4 py-3 text-center">
                <span class="inline-flex px-2.5 py-0.5 rounded-full text-xs font-medium" :class="statusClass(order.orderStatus)">
                  {{ order.orderStatus }}
                </span>
              </td>
              <td class="px-4 py-3 text-muted-foreground hidden lg:table-cell">{{ formatDate(order.createdAt) }}</td>
              <td class="px-4 py-3">
                <Icon name="lucide:chevron-right" class="w-4 h-4 text-muted-foreground ml-auto" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      <div v-if="total > limit" class="border-t border-border px-4 py-3 flex items-center justify-between text-sm">
        <span class="text-muted-foreground">{{ total }} órdenes</span>
        <div class="flex gap-2">
          <button :disabled="page === 1" class="px-3 py-1 rounded border border-border disabled:opacity-40 hover:bg-muted transition-colors" @click="page--; fetchOrders()">Anterior</button>
          <button :disabled="page * limit >= total" class="px-3 py-1 rounded border border-border disabled:opacity-40 hover:bg-muted transition-colors" @click="page++; fetchOrders()">Siguiente</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { getOrders, ORDER_STATUSES } = useAdminServices()
const orders = ref<any[]>([])
const total = ref(0)
const page = ref(1)
const limit = 20
const pending = ref(true)
const activeStatus = ref('')

async function fetchOrders() {
  pending.value = true
  try {
    const res: any = await getOrders({ page: page.value, limit, status: activeStatus.value || undefined })
    orders.value = res.orders ?? []
    total.value = res.total ?? 0
  } finally {
    pending.value = false
  }
}

onMounted(fetchOrders)

function formatDate(d: string | null) {
  if (!d) return '—'
  return new Intl.DateTimeFormat('es-CO', { day: '2-digit', month: 'short', year: 'numeric' }).format(new Date(d))
}

function statusClass(s: string | null) {
  const m: Record<string, string> = {
    Pending: 'bg-amber-100 text-amber-700',
    Confirmed: 'bg-blue-100 text-blue-700',
    Processed: 'bg-indigo-100 text-indigo-700',
    Shipped: 'bg-purple-100 text-purple-700',
    Delivered: 'bg-green-100 text-green-700',
    Cancelled: 'bg-red-100 text-red-700',
  }
  return m[s ?? ''] ?? 'bg-muted text-muted-foreground'
}
</script>
