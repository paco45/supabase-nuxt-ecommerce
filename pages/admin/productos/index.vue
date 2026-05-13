<template>
  <div class="space-y-4">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center gap-3">
      <div class="flex-1">
        <input
          v-model="search"
          type="text"
          placeholder="Buscar producto..."
          class="w-full sm:w-72 h-9 px-3 rounded-lg border border-border bg-card text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
          @input="debouncedFetch"
        />
      </div>
      <NuxtLink
        to="/admin/productos/nuevo"
        class="inline-flex items-center gap-2 h-9 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors"
      >
        <Icon name="lucide:plus" class="w-4 h-4" />
        Nuevo producto
      </NuxtLink>
    </div>

    <!-- Table -->
    <div class="bg-card rounded-xl border border-border overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-border bg-muted/40">
              <th class="text-left px-4 py-3 font-medium text-muted-foreground">Producto</th>
              <th class="text-left px-4 py-3 font-medium text-muted-foreground hidden md:table-cell">Categoría</th>
              <th class="text-right px-4 py-3 font-medium text-muted-foreground">Precio</th>
              <th class="text-center px-4 py-3 font-medium text-muted-foreground">Stock</th>
              <th class="text-center px-4 py-3 font-medium text-muted-foreground hidden sm:table-cell">Destacado</th>
              <th class="px-4 py-3"></th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-if="pending" v-for="i in 5" :key="i" class="animate-pulse">
              <td colspan="6" class="px-4 py-3">
                <div class="h-4 bg-muted rounded w-full" />
              </td>
            </tr>
            <tr v-else-if="!products?.length">
              <td colspan="6" class="px-4 py-12 text-center text-muted-foreground">
                No hay productos todavía.
                <NuxtLink to="/admin/productos/nuevo" class="text-primary ml-1 hover:underline">Crear el primero</NuxtLink>
              </td>
            </tr>
            <tr
              v-for="product in products"
              :key="product.id"
              class="hover:bg-muted/30 transition-colors"
            >
              <td class="px-4 py-3">
                <div class="flex items-center gap-3">
                  <img
                    v-if="product.primaryImage"
                    :src="product.primaryImage"
                    :alt="product.name"
                    class="w-10 h-10 rounded-lg object-cover bg-muted shrink-0"
                  />
                  <div v-else class="w-10 h-10 rounded-lg bg-muted shrink-0 flex items-center justify-center">
                    <Icon name="lucide:image" class="w-4 h-4 text-muted-foreground" />
                  </div>
                  <span class="font-medium truncate max-w-[160px]">{{ product.name }}</span>
                </div>
              </td>
              <td class="px-4 py-3 text-muted-foreground hidden md:table-cell">{{ product.skincareCategory ?? '—' }}</td>
              <td class="px-4 py-3 text-right font-medium">{{ formatCOP(product.unitPrice) }}</td>
              <td class="px-4 py-3 text-center">
                <span
                  class="inline-flex items-center justify-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                  :class="product.stockQuantity === 0
                    ? 'bg-red-100 text-red-700'
                    : product.stockQuantity < 5
                    ? 'bg-amber-100 text-amber-700'
                    : 'bg-green-100 text-green-700'"
                >
                  {{ product.stockQuantity }}
                </span>
              </td>
              <td class="px-4 py-3 text-center hidden sm:table-cell">
                <Icon
                  :name="product.isFeatured ? 'lucide:star' : 'lucide:star'"
                  class="w-4 h-4 mx-auto"
                  :class="product.isFeatured ? 'text-amber-400 fill-amber-400' : 'text-muted-foreground'"
                />
              </td>
              <td class="px-4 py-3">
                <div class="flex items-center justify-end gap-1">
                  <NuxtLink
                    :to="`/admin/productos/${product.id}`"
                    class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors"
                  >
                    <Icon name="lucide:pencil" class="w-3.5 h-3.5 text-muted-foreground" />
                  </NuxtLink>
                  <button
                    class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-red-50 hover:text-destructive transition-colors"
                    @click="confirmDelete(product)"
                  >
                    <Icon name="lucide:trash-2" class="w-3.5 h-3.5" />
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Pagination -->
      <div v-if="total > limit" class="border-t border-border px-4 py-3 flex items-center justify-between text-sm">
        <span class="text-muted-foreground">{{ total }} productos</span>
        <div class="flex gap-2">
          <button
            :disabled="page === 1"
            class="px-3 py-1 rounded border border-border disabled:opacity-40 hover:bg-muted transition-colors"
            @click="page--; fetchProducts()"
          >Anterior</button>
          <button
            :disabled="page * limit >= total"
            class="px-3 py-1 rounded border border-border disabled:opacity-40 hover:bg-muted transition-colors"
            @click="page++; fetchProducts()"
          >Siguiente</button>
        </div>
      </div>
    </div>

    <!-- Delete dialog -->
    <div
      v-if="deleteTarget"
      class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      @click.self="deleteTarget = null"
    >
      <div class="bg-card rounded-xl border border-border p-6 w-full max-w-sm shadow-xl">
        <h3 class="font-heading font-semibold text-lg mb-2">Eliminar producto</h3>
        <p class="text-sm text-muted-foreground mb-6">
          ¿Seguro que quieres eliminar <strong>{{ deleteTarget.name }}</strong>? Esta acción no se puede deshacer.
        </p>
        <div class="flex gap-3">
          <button
            class="flex-1 h-9 rounded-lg border border-border text-sm hover:bg-muted transition-colors"
            @click="deleteTarget = null"
          >Cancelar</button>
          <button
            class="flex-1 h-9 rounded-lg bg-destructive text-destructive-foreground text-sm font-medium hover:bg-destructive/90 transition-colors"
            :disabled="deleting"
            @click="doDelete"
          >{{ deleting ? 'Eliminando...' : 'Eliminar' }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { getProducts, deleteProduct } = useAdminServices()

const search = ref('')
const page = ref(1)
const limit = 20
const products = ref<any[]>([])
const total = ref(0)
const pending = ref(true)
const deleteTarget = ref<any>(null)
const deleting = ref(false)

async function fetchProducts() {
  pending.value = true
  try {
    const res: any = await getProducts({ page: page.value, search: search.value, limit })
    products.value = res.products ?? []
    total.value = res.total ?? 0
  } finally {
    pending.value = false
  }
}

const debouncedFetch = useDebounceFn(() => { page.value = 1; fetchProducts() }, 400)

onMounted(fetchProducts)

function formatCOP(value: number | null) {
  if (!value) return '—'
  return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', maximumFractionDigits: 0 }).format(value)
}

function confirmDelete(product: any) { deleteTarget.value = product }

async function doDelete() {
  if (!deleteTarget.value) return
  deleting.value = true
  try {
    await deleteProduct(deleteTarget.value.id)
    await fetchProducts()
    deleteTarget.value = null
  } finally {
    deleting.value = false
  }
}
</script>
