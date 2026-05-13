<template>
  <div class="max-w-3xl space-y-6">
    <div class="flex items-center gap-3">
      <NuxtLink to="/admin/productos" class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-muted transition-colors">
        <Icon name="lucide:arrow-left" class="w-4 h-4" />
      </NuxtLink>
      <h2 class="font-heading font-semibold text-lg">{{ initialData ? 'Editar producto' : 'Nuevo producto' }}</h2>
    </div>

    <form class="space-y-6" @submit.prevent="handleSubmit">
      <!-- Información básica -->
      <section class="bg-card rounded-xl border border-border p-5 space-y-4">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Información básica</h3>

        <div class="grid sm:grid-cols-2 gap-4">
          <div class="sm:col-span-2 space-y-1.5">
            <label class="text-sm font-medium">Nombre del producto *</label>
            <input v-model="form.name" type="text" required class="admin-input w-full" placeholder="Sérum vitamina C 30ml" />
          </div>
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Categoría skin care</label>
            <select v-model="form.skincareCategory" class="admin-input w-full">
              <option value="">Sin categoría</option>
              <option v-for="cat in SKINCARE_CATEGORIES" :key="cat" :value="cat">{{ cat }}</option>
            </select>
          </div>
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Volumen</label>
            <input v-model="form.volume" type="text" class="admin-input w-full" placeholder="30ml, 150ml..." />
          </div>
        </div>

        <div class="space-y-1.5">
          <label class="text-sm font-medium">Descripción corta</label>
          <input v-model="form.shortDescription" type="text" class="admin-input w-full" placeholder="Texto que aparece en la tarjeta del producto" />
        </div>

        <div class="space-y-1.5">
          <label class="text-sm font-medium">Descripción completa</label>
          <textarea v-model="form.description" rows="4" class="admin-input w-full resize-none" placeholder="Descripción detallada del producto..." />
        </div>
      </section>

      <!-- Precio y stock -->
      <section class="bg-card rounded-xl border border-border p-5 space-y-4">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Precio y stock</h3>
        <div class="grid sm:grid-cols-3 gap-4">
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Precio (COP) *</label>
            <input v-model.number="form.unitPrice" type="number" required min="0" class="admin-input w-full" placeholder="89900" />
          </div>
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Stock *</label>
            <input v-model.number="form.stockQuantity" type="number" required min="0" class="admin-input w-full" placeholder="0" />
          </div>
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Descuento (%)</label>
            <input v-model.number="form.discount" type="number" min="0" max="100" class="admin-input w-full" placeholder="0" />
          </div>
        </div>
      </section>

      <!-- Imágenes -->
      <section class="bg-card rounded-xl border border-border p-5 space-y-4">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Imágenes</h3>
        <div class="grid sm:grid-cols-2 gap-4">
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Imagen principal (URL)</label>
            <input v-model="form.primaryImage" type="url" class="admin-input w-full" placeholder="https://..." />
            <img v-if="form.primaryImage" :src="form.primaryImage" alt="preview" class="mt-2 h-24 w-24 object-cover rounded-lg border border-border" />
          </div>
          <div class="space-y-1.5">
            <label class="text-sm font-medium">Imagen hover (URL)</label>
            <input v-model="form.hoverImage" type="url" class="admin-input w-full" placeholder="https://..." />
          </div>
        </div>
        <div class="space-y-1.5">
          <label class="text-sm font-medium">Imágenes adicionales (una URL por línea)</label>
          <textarea
            :value="(form.imageUrls ?? []).join('\n')"
            rows="3"
            class="admin-input w-full resize-none font-mono text-xs"
            placeholder="https://imagen1.jpg&#10;https://imagen2.jpg"
            @input="(e) => form.imageUrls = (e.target as HTMLTextAreaElement).value.split('\n').filter(Boolean)"
          />
        </div>
      </section>

      <!-- Detalle del producto -->
      <section class="bg-card rounded-xl border border-border p-5 space-y-4">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide">Detalle del producto</h3>
        <div class="space-y-1.5">
          <label class="text-sm font-medium">Ingredientes</label>
          <textarea v-model="form.ingredients" rows="3" class="admin-input w-full resize-none" placeholder="Aqua, Niacinamide, Glycerin..." />
        </div>
        <div class="space-y-1.5">
          <label class="text-sm font-medium">Modo de uso</label>
          <textarea v-model="form.howToUse" rows="2" class="admin-input w-full resize-none" placeholder="Aplicar 2-3 gotas en el rostro limpio..." />
        </div>
        <div class="space-y-1.5">
          <label class="text-sm font-medium">Tipo de piel</label>
          <div class="flex flex-wrap gap-2">
            <label
              v-for="tipo in tiposPiel"
              :key="tipo"
              class="flex items-center gap-1.5 cursor-pointer text-sm px-3 py-1.5 rounded-full border transition-colors"
              :class="(form.skinType ?? []).includes(tipo) ? 'border-primary bg-primary/10 text-primary' : 'border-border hover:border-primary/50'"
            >
              <input type="checkbox" class="hidden" :checked="(form.skinType ?? []).includes(tipo)" @change="toggleSkinType(tipo)" />
              {{ tipo }}
            </label>
          </div>
        </div>
      </section>

      <!-- Opciones -->
      <section class="bg-card rounded-xl border border-border p-5">
        <h3 class="font-medium text-sm text-muted-foreground uppercase tracking-wide mb-4">Opciones</h3>
        <label class="flex items-center gap-3 cursor-pointer">
          <div
            class="w-10 h-6 rounded-full transition-colors relative"
            :class="form.isFeatured ? 'bg-primary' : 'bg-muted'"
            @click="form.isFeatured = !form.isFeatured"
          >
            <div
              class="absolute top-1 w-4 h-4 rounded-full bg-white transition-transform shadow"
              :class="form.isFeatured ? 'translate-x-5' : 'translate-x-1'"
            />
          </div>
          <span class="text-sm font-medium">Producto destacado</span>
          <span class="text-xs text-muted-foreground">(aparece en la sección principal)</span>
        </label>
      </section>

      <!-- Actions -->
      <div class="flex gap-3">
        <NuxtLink to="/admin/productos" class="h-10 px-5 rounded-lg border border-border text-sm font-medium hover:bg-muted transition-colors flex items-center">
          Cancelar
        </NuxtLink>
        <button
          type="submit"
          :disabled="loading"
          class="h-10 px-6 rounded-lg bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors disabled:opacity-60 flex items-center gap-2"
        >
          <Icon v-if="loading" name="lucide:loader-2" class="w-4 h-4 animate-spin" />
          {{ loading ? 'Guardando...' : initialData ? 'Guardar cambios' : 'Crear producto' }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{ initialData?: Record<string, any>; loading?: boolean }>()
const emit = defineEmits<{ submit: [data: Record<string, unknown>] }>()

const { SKINCARE_CATEGORIES } = useAdminServices()

const tiposPiel = ['Normal', 'Grasa', 'Seca', 'Mixta', 'Sensible']

const form = reactive({
  name: '',
  skincareCategory: '' as string,
  volume: '',
  shortDescription: '',
  description: '',
  unitPrice: null as number | null,
  stockQuantity: 0,
  discount: null as number | null,
  primaryImage: '',
  hoverImage: '',
  imageUrls: [] as string[],
  ingredients: '',
  howToUse: '',
  skinType: [] as string[],
  isFeatured: false,
})

if (props.initialData) Object.assign(form, props.initialData)

function toggleSkinType(tipo: string) {
  const arr = form.skinType ?? []
  const idx = arr.indexOf(tipo)
  if (idx >= 0) arr.splice(idx, 1)
  else arr.push(tipo)
}

function handleSubmit() {
  const data: Record<string, unknown> = { ...form }
  if (!data.skincareCategory) delete data.skincareCategory
  if (!data.discount) delete data.discount
  emit('submit', data)
}
</script>

<style scoped>
.admin-input {
  @apply h-9 px-3 rounded-lg border border-border bg-background text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-shadow;
}
textarea.admin-input {
  @apply h-auto py-2;
}
</style>
