<script lang="ts" setup>
import { useCartStore } from '~/store/cart'
import type { Tables } from '~/types/database.types'

type Product = Tables<'products'>

const searchKey = ref('')
const mobileMenuOpen = ref(false)
const user = useSupabaseUser()
const products = ref<Product[]>([])
const { searchProduct } = useApiServices()

const links = [
  { to: '/', label: 'Inicio' },
  { to: '/collections/serums', label: 'Sérums' },
  { to: '/collections/hidratantes', label: 'Hidratantes' },
  { to: '/collections/proteccion-solar', label: 'Protección Solar' },
  { to: '/collections/kits', label: 'Kits' },
]

const { totalQuantity, isMiniCartVisible } = storeToRefs(useCartStore())

const selectProduct = (product: Product) => {
  searchKey.value = ''
  navigateTo(`/products/${product.slug}`)
}

const navigateToUser = () =>
  user.value ? navigateTo('/account/profile') : navigateTo('/account/login')

watchDebounced(
  searchKey,
  async (value) => {
    products.value = value.length > 1 ? await searchProduct(value) : []
  },
  { debounce: 300 },
)
</script>

<template>
  <header class="sticky top-0 z-[1000] bg-background/95 backdrop-blur-sm border-b border-border">
    <div class="px-4 sm:px-6 lg:px-16 mx-auto py-3">
      <div class="flex items-center gap-4">
        <!-- Logo -->
        <CommonAppLogo />

        <!-- Búsqueda desktop -->
        <div class="hidden sm:flex flex-1 max-w-sm mx-4 relative">
          <CommonAppSearchBar v-model="searchKey" class="w-full" />
          <ProductResultsDropdown :products @select="selectProduct" />
        </div>

        <div class="flex-1" />

        <!-- Iconos -->
        <div class="flex items-center gap-1">
          <!-- Wishlist -->
          <NuxtLink to="/wishlist" class="p-2 hover:text-primary transition-colors hidden sm:flex">
            <Icon name="lucide:heart" class="w-5 h-5" />
          </NuxtLink>

          <!-- Usuario -->
          <button class="p-2 hover:text-primary transition-colors hidden sm:flex" @click="navigateToUser">
            <Icon name="lucide:user" class="w-5 h-5" />
          </button>

          <!-- Admin shortcut (solo si es admin) -->
          <NuxtLink v-if="user" to="/admin" class="p-2 hover:text-primary transition-colors hidden sm:flex">
            <Icon name="lucide:layout-dashboard" class="w-5 h-5" />
          </NuxtLink>

          <!-- Dark mode -->
          <CommonAppColorMode class="p-2" />

          <!-- Carrito -->
          <div
            class="relative p-2 hover:text-primary transition-colors cursor-pointer"
            @mouseenter="isMiniCartVisible = true"
            @mouseleave="isMiniCartVisible = false"
          >
            <Icon name="lucide:shopping-bag" class="w-5 h-5" />
            <span
              v-if="totalQuantity > 0"
              class="absolute top-0.5 right-0.5 w-4 h-4 rounded-full bg-primary text-primary-foreground text-[0.6rem] flex items-center justify-center font-medium"
            >{{ totalQuantity }}</span>
            <CartDropdown v-show="isMiniCartVisible" class="absolute right-0 top-full" />
          </div>

          <!-- Menú mobile -->
          <button class="p-2 sm:hidden hover:text-primary transition-colors" @click="mobileMenuOpen = !mobileMenuOpen">
            <Icon :name="mobileMenuOpen ? 'lucide:x' : 'lucide:menu'" class="w-5 h-5" />
          </button>
        </div>
      </div>

      <!-- Búsqueda mobile -->
      <div class="sm:hidden mt-2">
        <CommonAppSearchBar v-model="searchKey" class="w-full" />
        <ProductResultsDropdown :products @select="selectProduct" />
      </div>

      <!-- Nav desktop -->
      <nav class="hidden sm:flex mt-3 justify-center">
        <ul class="flex gap-6 lg:gap-8">
          <li v-for="link in links" :key="link.label">
            <NuxtLink
              :to="link.to"
              class="text-sm font-medium text-foreground/70 hover:text-primary transition-colors pb-1 border-b-2 border-transparent hover:border-primary/40"
              active-class="text-primary border-primary"
            >{{ link.label }}</NuxtLink>
          </li>
        </ul>
      </nav>
    </div>

    <!-- Mobile menu -->
    <Transition name="fade">
      <div v-if="mobileMenuOpen" class="sm:hidden border-t border-border bg-background">
        <nav class="px-4 py-3 space-y-1">
          <NuxtLink
            v-for="link in links"
            :key="link.label"
            :to="link.to"
            class="block px-3 py-2.5 rounded-lg text-sm font-medium hover:bg-muted transition-colors"
            @click="mobileMenuOpen = false"
          >{{ link.label }}</NuxtLink>
          <div class="border-t border-border pt-2 mt-2 flex gap-2">
            <button class="flex-1 flex items-center gap-2 px-3 py-2.5 rounded-lg text-sm hover:bg-muted transition-colors" @click="navigateToUser">
              <Icon name="lucide:user" class="w-4 h-4" /> Mi cuenta
            </button>
            <NuxtLink to="/wishlist" class="flex-1 flex items-center gap-2 px-3 py-2.5 rounded-lg text-sm hover:bg-muted transition-colors">
              <Icon name="lucide:heart" class="w-4 h-4" /> Favoritos
            </NuxtLink>
          </div>
        </nav>
      </div>
    </Transition>
  </header>
</template>

<style scoped>
.fade-enter-active { animation: slide-in 0.2s ease forwards; }
.fade-leave-active { animation: slide-out 0.2s ease forwards; }
@keyframes slide-in { from { opacity:0; transform:translateY(-8px) } to { opacity:1; transform:translateY(0) } }
@keyframes slide-out { from { opacity:1; transform:translateY(0) } to { opacity:0; transform:translateY(-8px) } }
</style>
