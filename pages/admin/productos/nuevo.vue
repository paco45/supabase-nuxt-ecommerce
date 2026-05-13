<template>
  <AdminProductoForm :loading="saving" @submit="handleCreate" />
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { createProduct } = useAdminServices()
const saving = ref(false)

async function handleCreate(data: Record<string, unknown>) {
  saving.value = true
  try {
    await createProduct(data)
    navigateTo('/admin/productos')
  } finally {
    saving.value = false
  }
}
</script>
