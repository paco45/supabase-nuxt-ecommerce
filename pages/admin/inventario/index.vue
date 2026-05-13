<template>
  <div class="space-y-4">
    <p class="text-sm text-muted-foreground">Actualiza el stock de cada producto directamente desde aquí.</p>

    <div class="bg-card rounded-xl border border-border overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead>
            <tr class="border-b border-border bg-muted/40">
              <th class="text-left px-4 py-3 font-medium text-muted-foreground">Producto</th>
              <th class="text-left px-4 py-3 font-medium text-muted-foreground hidden md:table-cell">Categoría</th>
              <th class="text-center px-4 py-3 font-medium text-muted-foreground w-36">Stock</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-if="pending" v-for="i in 8" :key="i" class="animate-pulse">
              <td colspan="3" class="px-4 py-3"><div class="h-4 bg-muted rounded w-full" /></td>
            </tr>
            <tr v-for="product in products" :key="product.id" class="hover:bg-muted/30 transition-colors">
              <td class="px-4 py-3">
                <div class="flex items-center gap-3">
                  <img v-if="product.primaryImage" :src="product.primaryImage" :alt="product.name" class="w-9 h-9 rounded-lg object-cover bg-muted shrink-0" />
                  <div v-else class="w-9 h-9 rounded-lg bg-muted shrink-0" />
                  <span class="font-medium truncate max-w-[180px]">{{ product.name }}</span>
                </div>
              </td>
              <td class="px-4 py-3 text-muted-foreground hidden md:table-cell">{{ product.skincareCategory ?? '—' }}</td>
              <td class="px-4 py-3">
                <div class="flex items-center gap-2 justify-center">
                  <button
                    class="w-7 h-7 rounded-lg border border-border flex items-center justify-center hover:bg-muted transition-colors"
                    @click="adjustStock(product, -1)"
                  ><Icon name="lucide:minus" class="w-3 h-3" /></button>
                  <span
                    class="w-10 text-center font-medium tabular-nums"
                    :class="product.stockQuantity === 0 ? 'text-destructive' : product.stockQuantity < 5 ? 'text-amber-600' : ''"
                  >{{ product.stockQuantity }}</span>
                  <button
                    class="w-7 h-7 rounded-lg border border-border flex items-center justify-center hover:bg-muted transition-colors"
                    @click="adjustStock(product, 1)"
                  ><Icon name="lucide:plus" class="w-3 h-3" /></button>
                  <button
                    v-if="dirty.has(product.id)"
                    class="ml-1 h-7 px-2.5 rounded-lg bg-primary text-primary-foreground text-xs font-medium hover:bg-primary/90 transition-colors"
                    :disabled="saving === product.id"
                    @click="saveStock(product)"
                  >
                    <Icon v-if="saving === product.id" name="lucide:loader-2" class="w-3 h-3 animate-spin" />
                    <span v-else>Guardar</span>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { getProducts, updateStock } = useAdminServices()

const products = ref<any[]>([])
const pending = ref(true)
const saving = ref<number | null>(null)
const dirty = ref(new Set<number>())

onMounted(async () => {
  const res: any = await getProducts({ limit: 100 })
  products.value = res.products ?? []
  pending.value = false
})

function adjustStock(product: any, delta: number) {
  const next = Math.max(0, product.stockQuantity + delta)
  product.stockQuantity = next
  dirty.value.add(product.id)
}

async function saveStock(product: any) {
  saving.value = product.id
  try {
    await updateStock(product.id, product.stockQuantity)
    dirty.value.delete(product.id)
  } finally {
    saving.value = null
  }
}
</script>
