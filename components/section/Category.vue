<template>
  <section class="px-4 sm:px-6 lg:px-16 py-10">
    <div class="max-w-6xl mx-auto">
      <!-- Header -->
      <div class="text-center mb-8">
        <h2 class="font-heading text-3xl sm:text-4xl font-semibold text-foreground">
          Explora por <span class="text-primary italic">categoría</span>
        </h2>
        <p class="text-sm text-muted-foreground mt-2">Encuentra exactamente lo que tu piel necesita</p>
      </div>

      <!-- Grid -->
      <div class="grid grid-cols-2 sm:grid-cols-3 gap-3 sm:gap-4">
        <template v-if="isLoading">
          <div v-for="n in 6" :key="n" class="aspect-square rounded-2xl bg-muted animate-pulse" />
        </template>
        <template v-else>
          <NuxtLink
            v-for="category in categories"
            :key="category.id"
            :to="`/collections/${category.slug}`"
            class="group relative overflow-hidden rounded-2xl aspect-square cursor-pointer"
          >
            <!-- Image -->
            <img
              v-if="category.backgroundImage"
              :src="category.backgroundImage"
              :alt="category.name"
              class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
            />
            <div v-else class="w-full h-full bg-gradient-to-br from-primary/20 to-accent" />

            <!-- Overlay -->
            <div class="absolute inset-0 bg-gradient-to-t from-foreground/70 via-foreground/20 to-transparent" />

            <!-- Label -->
            <div class="absolute bottom-0 left-0 right-0 p-4">
              <p class="text-white font-heading text-lg sm:text-xl lg:text-2xl font-semibold leading-snug drop-shadow-sm">
                {{ category.name }}
              </p>
              <p class="text-white/70 text-xs mt-0.5 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                Ver productos <Icon name="lucide:arrow-right" class="w-3 h-3" />
              </p>
            </div>
          </NuxtLink>
        </template>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import type { Tables } from '~/types/database.types'

const supabase = useSupabaseClient()

const categories = ref<Tables<'categories'>[]>([])
const isLoading = ref(true)

async function fetchCategories() {
  isLoading.value = true
  const { data, error } = await supabase
    .from('categories')
    .select('*')
    .order('id', { ascending: true })
    .limit(6)
  if (!error && data) {
    categories.value = data
  }
  isLoading.value = false
}

fetchCategories()
</script>
