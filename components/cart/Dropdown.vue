<template>
  <div class="w-[340px] sm:w-[400px] bg-card border border-border rounded-2xl shadow-lg overflow-hidden">
    <!-- Header -->
    <div class="px-4 py-3 border-b border-border flex items-center justify-between">
      <h3 class="text-sm font-semibold text-foreground">
        Mi carrito
        <span class="ml-1 text-muted-foreground font-normal">({{ totalQuantity }})</span>
      </h3>
    </div>

    <!-- Items -->
    <div v-if="cartItems.length > 0">
      <ul class="max-h-[340px] overflow-y-auto divide-y divide-border">
        <li
          v-for="(item, index) in cartItems"
          :key="item.productId ?? `fallback-${index}`"
        >
          <CartItem
            variant="dropdown"
            :item
            @decrease-quantity="decreaseItemQuantity(index)"
            @increase-quantity="increaseItemQuantity(index)"
            @remove-item="removeCartItem(index)"
          />
        </li>
      </ul>

      <div class="px-4 py-3 border-t border-border space-y-3">
        <!-- Trust badges -->
        <div class="flex gap-3 text-[11px] text-muted-foreground">
          <span class="flex items-center gap-1">
            <Icon name="lucide:truck" class="w-3.5 h-3.5 text-primary" /> Envío a Colombia
          </span>
          <span class="flex items-center gap-1">
            <Icon name="lucide:shield-check" class="w-3.5 h-3.5 text-green-500" /> Pago seguro
          </span>
        </div>

        <!-- Total -->
        <div class="flex justify-between items-center text-sm font-semibold">
          <span>Total</span>
          <span class="text-primary text-base">{{ formatCOP(cart?.totalprice ?? 0) }}</span>
        </div>

        <!-- CTA -->
        <button
          class="w-full h-10 rounded-xl bg-foreground text-background text-sm font-semibold hover:bg-foreground/90 transition-colors"
          @click="navigateToCart"
        >
          Ir al pago
        </button>
      </div>
    </div>

    <!-- Empty state -->
    <div v-else class="flex flex-col items-center justify-center py-10 px-4 text-center">
      <div class="w-14 h-14 rounded-full bg-muted flex items-center justify-center mb-3">
        <Icon name="lucide:shopping-bag" class="w-6 h-6 text-muted-foreground" />
      </div>
      <p class="text-sm font-medium text-foreground mb-1">Tu carrito está vacío</p>
      <p class="text-xs text-muted-foreground mb-4">Agrega productos para comenzar</p>
      <button
        class="h-9 px-5 rounded-xl bg-primary text-primary-foreground text-xs font-medium hover:bg-primary/90 transition-colors"
        @click="navigateToAllProducts"
      >
        Ver productos
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '~/store/cart'

const cartStore = useCartStore()
const { decreaseItemQuantity, increaseItemQuantity, removeCartItem } = cartStore
const { totalQuantity, cartItems, cart } = storeToRefs(cartStore)
const router = useRouter()

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency', currency: 'COP', maximumFractionDigits: 0,
  }).format(value)
}

function navigateToCart() {
  router.push('/checkout')
}

function navigateToAllProducts() {
  router.push('/collections/serums')
}
</script>
