<template>
  <div v-if="pending" class="flex justify-center py-20">
    <Icon name="lucide:loader-2" class="w-6 h-6 animate-spin text-muted-foreground" />
  </div>

  <div v-else-if="order" class="max-w-2xl space-y-5">
    <div class="flex items-center gap-3">
      <NuxtLink to="/admin/ordenes" class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors">
        <Icon name="lucide:arrow-left" class="w-4 h-4" />
      </NuxtLink>
      <h2 class="font-heading font-semibold text-lg">Orden #{{ order.id }}</h2>
      <span class="ml-auto px-3 py-1 rounded-full text-sm font-medium" :class="statusClass(order.orderStatus)">
        {{ order.orderStatus }}
      </span>
    </div>

    <!-- Info + cambio de estado -->
    <div class="bg-card rounded-xl border border-border p-5 space-y-4">
      <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Estado de la orden</h3>
      <div class="flex flex-wrap gap-2">
        <button
          v-for="s in ORDER_STATUSES"
          :key="s"
          :disabled="updating || order.orderStatus === s"
          class="px-3 py-1.5 rounded-full text-xs font-medium border transition-colors disabled:opacity-50"
          :class="order.orderStatus === s
            ? 'bg-primary text-primary-foreground border-primary'
            : 'border-border hover:border-primary/50'"
          @click="changeStatus(s)"
        >
          <Icon v-if="updating && pendingStatus === s" name="lucide:loader-2" class="w-3 h-3 inline animate-spin mr-1" />
          {{ s }}
        </button>
      </div>
    </div>

    <!-- Dirección -->
    <div v-if="order.addresses" class="bg-card rounded-xl border border-border p-5">
      <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide mb-3">Envío a</h3>
      <p class="font-medium">{{ order.addresses.name }}</p>
      <p class="text-sm text-muted-foreground">{{ order.addresses.address }}</p>
      <p class="text-sm text-muted-foreground">{{ order.addresses.city }}, {{ order.addresses.country }}</p>
    </div>

    <!-- Productos de la orden -->
    <div class="bg-card rounded-xl border border-border overflow-hidden">
      <div class="p-4 border-b border-border">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Productos</h3>
      </div>
      <div class="divide-y divide-border">
        <div v-for="item in order.orderItems" :key="item.id" class="flex items-center gap-4 p-4">
          <img
            v-if="item.products?.primaryImage"
            :src="item.products.primaryImage"
            :alt="item.products?.name"
            class="w-12 h-12 rounded-lg object-cover bg-muted shrink-0"
          />
          <div v-else class="w-12 h-12 rounded-lg bg-muted shrink-0" />
          <div class="flex-1 min-w-0">
            <p class="font-medium truncate">{{ item.products?.name }}</p>
            <p class="text-sm text-muted-foreground">{{ item.quantity }} × {{ formatCOP(item.price) }}</p>
          </div>
          <p class="font-medium shrink-0">{{ formatCOP((item.price ?? 0) * (item.quantity ?? 1)) }}</p>
        </div>
      </div>
    </div>

    <!-- MercadoPago info -->
    <div v-if="order.mercadopagoId" class="bg-card rounded-xl border border-border p-5">
      <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide mb-3">Pago</h3>
      <div class="grid grid-cols-2 gap-3 text-sm">
        <div>
          <p class="text-muted-foreground">ID MercadoPago</p>
          <p class="font-mono">{{ order.mercadopagoId }}</p>
        </div>
        <div>
          <p class="text-muted-foreground">Estado pago</p>
          <p>{{ order.mercadopagoStatus ?? '—' }}</p>
        </div>
        <div>
          <p class="text-muted-foreground">Método</p>
          <p>{{ order.paymentMethod ?? '—' }}</p>
        </div>
      </div>
    </div>

    <p class="text-xs text-muted-foreground">Creada el {{ formatDate(order.createdAt) }}</p>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const route = useRoute()
const { getOrder, updateOrderStatus, ORDER_STATUSES } = useAdminServices()

const { data, pending, refresh } = await useAsyncData(
  `order-${route.params.id}`,
  () => getOrder(Number(route.params.id)),
)
const order = computed(() => (data.value as any)?.order)

const updating = ref(false)
const pendingStatus = ref('')

async function changeStatus(status: string) {
  updating.value = true
  pendingStatus.value = status
  try {
    await updateOrderStatus(Number(route.params.id), status as any)
    await refresh()
  } finally {
    updating.value = false
    pendingStatus.value = ''
  }
}

function formatCOP(v: number | null) {
  if (!v) return '—'
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(v)
}

function formatDate(d: string | null) {
  if (!d) return '—'
  return new Intl.DateTimeFormat('es-CO', { dateStyle: 'long', timeStyle: 'short' }).format(new Date(d))
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
