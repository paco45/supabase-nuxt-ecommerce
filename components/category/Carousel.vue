<template>
  <div>
    <!-- Section header -->
    <div class="flex items-center justify-between mb-5">
      <div>
        <h2 v-if="categoryName" class="font-heading text-2xl sm:text-3xl font-semibold text-foreground">
          {{ categoryName }}
        </h2>
        <div v-else class="h-8 w-44 rounded-lg bg-muted animate-pulse" />
      </div>
      <NuxtLink
        v-if="categorySlug"
        :to="`/collections/${categorySlug}`"
        class="text-sm text-primary font-medium hover:underline underline-offset-2 flex items-center gap-1"
      >
        Ver todos <Icon name="lucide:arrow-right" class="w-3.5 h-3.5" />
      </NuxtLink>
    </div>

    <!-- Swiper -->
    <div class="swiper-container relative">
      <Swiper
        v-if="products.length"
        ref="swiperRef"
        :slides-per-view="slidesPerView"
        :modules="[SwiperNavigation]"
        :space-between="16"
        :loop="products.length > slidesPerView"
        @swiper="onSwiper"
      >
        <SwiperSlide v-for="product in products" :key="product.id">
          <ProductCard :product="product" />
        </SwiperSlide>
      </Swiper>
      <div v-else class="flex gap-4">
        <ProductCardSkeleton
          v-for="i in slidesPerView"
          :key="i"
          class="h-72 w-full"
        />
      </div>

      <!-- Nav arrows -->
      <button
        v-if="products.length > slidesPerView"
        class="absolute top-1/3 -translate-y-1/2 -left-3 lg:-left-5 z-50 w-9 h-9 rounded-full bg-background border border-border shadow-sm flex items-center justify-center hover:bg-muted transition-colors"
        type="button"
        @click="swiperPrevSlide"
      >
        <Icon name="lucide:chevron-left" class="w-4 h-4" />
      </button>
      <button
        v-if="products.length > slidesPerView"
        class="absolute top-1/3 -translate-y-1/2 -right-3 lg:-right-5 z-50 w-9 h-9 rounded-full bg-background border border-border shadow-sm flex items-center justify-center hover:bg-muted transition-colors"
        type="button"
        @click="swiperNextSlide"
      >
        <Icon name="lucide:chevron-right" class="w-4 h-4" />
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Tables } from '~/types/database.types'

interface Props {
  categoryId: number
}
const props = defineProps<Props>()

const { width } = useWindowSize()
const supabase = useSupabaseClient()

const categoryName = ref<string>('')
const categorySlug = ref<string>('')
const products = ref<Tables<'products'>[]>([])
const swiperInstance = ref()

const slidesPerView = computed(() => {
  if (width.value < 640) return 2
  if (width.value < 1024) return 3
  return 4
})

function onSwiper(swiper: any) {
  swiperInstance.value = swiper
}

function swiperPrevSlide() {
  swiperInstance.value?.slidePrev()
}

function swiperNextSlide() {
  swiperInstance.value?.slideNext()
}

async function fetchCategoryName() {
  const { data } = await supabase
    .from('categories')
    .select('name,slug')
    .eq('id', props.categoryId)
    .single()
  if (data) {
    categoryName.value = data.name
    categorySlug.value = data.slug ?? ''
  }
}

async function fetchProductsByCategoryId() {
  const { data } = await supabase
    .from('products_categories')
    .select('products(*)')
    .eq('categoryId', props.categoryId)
    .limit(10)
  if (data) {
    products.value = data
      .map((d: any) => d.products)
      .filter((p: any): p is Tables<'products'> => p !== null)
  }
}

fetchProductsByCategoryId()
fetchCategoryName()
</script>
