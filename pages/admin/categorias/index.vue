<template>
  <div class="max-w-2xl space-y-4">
    <!-- Nueva categoría -->
    <div class="bg-card rounded-xl border border-border p-5 space-y-3">
      <h3 class="font-medium">Nueva categoría</h3>
      <div class="flex gap-3">
        <input
          v-model="newName"
          type="text"
          placeholder="Nombre de la categoría..."
          class="flex-1 h-9 px-3 rounded-lg border border-border bg-background text-sm focus:outline-none focus:ring-2 focus:ring-primary/30"
          @keydown.enter="createCat"
        />
        <button
          :disabled="!newName.trim() || creating"
          class="h-9 px-4 rounded-lg bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors disabled:opacity-50 flex items-center gap-2"
          @click="createCat"
        >
          <Icon v-if="creating" name="lucide:loader-2" class="w-3.5 h-3.5 animate-spin" />
          <Icon v-else name="lucide:plus" class="w-3.5 h-3.5" />
          Agregar
        </button>
      </div>
    </div>

    <!-- Lista -->
    <div class="bg-card rounded-xl border border-border overflow-hidden">
      <div class="p-4 border-b border-border">
        <h3 class="font-medium">Categorías ({{ categories?.length ?? 0 }})</h3>
      </div>
      <div class="divide-y divide-border">
        <div v-if="pending" v-for="i in 5" :key="i" class="px-4 py-3 animate-pulse">
          <div class="h-4 bg-muted rounded w-48" />
        </div>
        <div
          v-for="cat in categories"
          :key="cat.id"
          class="flex items-center gap-4 px-4 py-3"
        >
          <div class="flex-1 min-w-0">
            <template v-if="editingId === cat.id">
              <input
                v-model="editName"
                class="h-8 px-2 rounded border border-primary text-sm w-full focus:outline-none"
                @keydown.enter="saveEdit(cat)"
                @keydown.escape="editingId = null"
              />
            </template>
            <template v-else>
              <p class="font-medium">{{ cat.name }}</p>
              <p class="text-xs text-muted-foreground">{{ cat.slug }}</p>
            </template>
          </div>
          <div class="flex items-center gap-1 shrink-0">
            <template v-if="editingId === cat.id">
              <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-green-50 text-green-600 transition-colors" @click="saveEdit(cat)">
                <Icon name="lucide:check" class="w-4 h-4" />
              </button>
              <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors" @click="editingId = null">
                <Icon name="lucide:x" class="w-4 h-4" />
              </button>
            </template>
            <template v-else>
              <button
                class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors text-muted-foreground"
                @click="startEdit(cat)"
              >
                <Icon name="lucide:pencil" class="w-3.5 h-3.5" />
              </button>
              <button
                class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-red-50 hover:text-destructive transition-colors text-muted-foreground"
                @click="deleteCat(cat)"
              >
                <Icon name="lucide:trash-2" class="w-3.5 h-3.5" />
              </button>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: 'admin' })

const { getCategories, createCategory, updateCategory, deleteCategory } = useAdminServices()

const { data, pending, refresh } = await useAsyncData('admin-cats', getCategories)
const categories = computed(() => (data.value as any)?.categories ?? [])

const newName = ref('')
const creating = ref(false)
const editingId = ref<number | null>(null)
const editName = ref('')

async function createCat() {
  if (!newName.value.trim()) return
  creating.value = true
  try {
    await createCategory({ name: newName.value.trim() })
    newName.value = ''
    await refresh()
  } finally {
    creating.value = false
  }
}

function startEdit(cat: any) {
  editingId.value = cat.id
  editName.value = cat.name
}

async function saveEdit(cat: any) {
  if (!editName.value.trim()) return
  await updateCategory(cat.id, { name: editName.value.trim() })
  editingId.value = null
  await refresh()
}

async function deleteCat(cat: any) {
  if (!confirm(`¿Eliminar la categoría "${cat.name}"?`)) return
  await deleteCategory(cat.id)
  await refresh()
}
</script>
