<template>
  <div
    ref="cardRef"
    class="group relative bg-card rounded-2xl border border-border overflow-hidden hover:shadow-md transition-all duration-300"
    @touchstart="handleTouchStart"
  >
    <!-- Imagen -->
    <NuxtLink :to="`/products/${product.slug}`" class="block relative overflow-hidden">
      <div class="aspect-square bg-muted overflow-hidden">
        <img
          v-if="product.primaryImage"
          loading="lazy"
          :src="showHover && product.hoverImage ? product.hoverImage : product.primaryImage"
          :alt="product.name"
          class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
        />
        <div v-else class="w-full h-full flex items-center justify-center text-muted-foreground">
          <Icon name="lucide:image" class="w-10 h-10" />
        </div>
      </div>

      <!-- Badges -->
      <div class="absolute top-2.5 left-2.5 flex flex-col gap-1.5">
        <span v-if="product.discount" class="px-2 py-0.5 rounded-full bg-primary text-primary-foreground text-[11px] font-semibold">
          -{{ product.discount }}%
        </span>
        <span v-if="!product.inStock" class="px-2 py-0.5 rounded-full bg-foreground/80 text-background text-[11px] font-medium">
          Agotado
        </span>
      </div>

      <!-- Wishlist -->
      <button
        class="absolute top-2.5 right-2.5 w-8 h-8 rounded-full bg-background/80 backdrop-blur-sm flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity hover:bg-background"
        @click.stop.prevent="toggleWishList"
      >
        <Icon
          name="lucide:heart"
          class="w-4 h-4 transition-colors"
          :class="isOnWishList ? 'text-primary fill-primary' : 'text-foreground'"
        />
      </button>

      <!-- Botón agregar al carrito -->
      <div
        class="absolute bottom-0 left-0 right-0 p-2 translate-y-full group-hover:translate-y-0 transition-transform duration-300"
        :class="{ '!translate-y-0': isMobileActive }"
      >
        <button
          :disabled="!product.inStock"
          class="w-full h-9 rounded-xl bg-foreground text-background text-xs font-semibold hover:bg-foreground/90 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          @click.stop.prevent="addToCart"
        >
          {{ product.inStock ? 'Agregar al carrito' : 'Sin stock' }}
        </button>
      </div>
    </NuxtLink>

    <!-- Info -->
    <div class="p-3">
      <p v-if="product.skincareCategory" class="text-[11px] text-primary font-medium mb-1">
        {{ product.skincareCategory }}
      </p>
      <NuxtLink :to="`/products/${product.slug}`" class="block">
        <h3 class="text-sm font-semibold leading-snug line-clamp-2 hover:text-primary transition-colors">
          {{ product.name }}
        </h3>
      </NuxtLink>
      <p v-if="product.shortDescription" class="text-[11px] text-muted-foreground mt-1 line-clamp-1">
        {{ product.shortDescription }}
      </p>

      <!-- Precio -->
      <div class="flex items-center gap-2 mt-2">
        <span class="text-sm font-semibold">{{ formatCOP(finalPrice) }}</span>
        <span v-if="product.discount" class="text-xs text-muted-foreground line-through">
          {{ formatCOP(product.unitPrice ?? 0) }}
        </span>
      </div>
    </div>

    <DialogAuthDialog v-model="isDialogOpen" />
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '~/store/cart'
import { useWishlistStore } from '~/store/wishlist'
import type { Tables, TablesInsert } from '~/types/database.types'

type Product = Tables<'products'>
type CartItem = TablesInsert<'cartItems'>

const props = defineProps<{ product: Product }>()

const cardRef = ref<HTMLElement | null>(null)
const isDialogOpen = ref(false)
const showHover = useElementHover(cardRef)

const cartStore = useCartStore()
const wishlistStore = useWishlistStore()
const { wishlist } = storeToRefs(wishlistStore)
const user = useSupabaseUser()
const { isMobile } = useUtilities()
const { activeProductId, setActiveProduct } = useActiveTouchProduct()

const isMobileActive = computed(() => activeProductId.value === props.product.id)
const isOnWishList = computed(() => wishlist.value.some(w => w.product_id === props.product.id))

const finalPrice = computed(() => {
  if (!props.product.unitPrice) return 0
  if (!props.product.discount) return props.product.unitPrice
  return props.product.unitPrice * (1 - props.product.discount / 100)
})

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency', currency: 'COP', maximumFractionDigits: 0,
  }).format(value)
}

function handleTouchStart() {
  if (isMobile.value) setActiveProduct(props.product.id)
}

function toggleWishList() {
  if (!user.value) { isDialogOpen.value = true; return }
  isOnWishList.value
    ? wishlistStore.removeFromWishList(props.product.id)
    : wishlistStore.addToWishlist(props.product.id)
}

function addToCart() {
  const item: CartItem = {
    price: finalPrice.value,
    productId: props.product.id,
    quantity: 1,
    id: crypto.randomUUID(),
  }
  cartStore.addToCart(item)
}
</script>
