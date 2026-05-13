<template>
  <AdminProductoForm
    v-if="product"
    :initial-data="product"
    :loading="saving"
    @submit="handleUpdate"
  />
  <div v-else-if="pending" class="flex items-center justify-center py-20">
    <Icon name="lucide:loader-2" class="w-6 h-6 animate-spin text-muted-foreground" />
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const route = useRoute()
const { getProduct, updateProduct } = useAdminServices()
const saving = ref(false)

const { data, pending } = await useAsyncData(
  `product-${route.params.id}`,
  () => getProduct(Number(route.params.id)),
)
const product = computed(() => (data.value as any)?.product)

async function handleUpdate(formData: Record<string, unknown>) {
  saving.value = true
  try {
    await updateProduct(Number(route.params.id), formData)
    navigateTo('/admin/productos')
  } finally {
    saving.value = false
  }
}
</script>
