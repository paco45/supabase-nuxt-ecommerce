<template>
  <div class="container mx-auto px-4 sm:px-6 lg:px-16 py-8">
    <h1 class="font-heading text-3xl font-semibold mb-8">Mi carrito</h1>

    <div v-if="cartItems.length > 0" class="grid lg:grid-cols-3 gap-8">
      <!-- Items list -->
      <div class="lg:col-span-2">
        <!-- Desktop header -->
        <div class="hidden sm:grid grid-cols-[1fr_7rem_9rem_7rem_2rem] gap-4 pb-3 border-b border-border text-xs font-medium text-muted-foreground uppercase tracking-wide">
          <span>Producto</span>
          <span class="text-center">Precio</span>
          <span class="text-center">Cantidad</span>
          <span class="text-right">Total</span>
          <span />
        </div>

        <div class="divide-y divide-border sm:divide-y-0">
          <CartItem
            v-for="(item, idx) in cartItems"
            :key="item.productId ?? `fallback-${idx}`"
            :item="item"
            :variant="isMobile ? 'dropdown' : 'full'"
            @decrease-quantity="decreaseItemQuantity(idx)"
            @increase-quantity="increaseItemQuantity(idx)"
            @remove-item="removeCartItem(idx)"
          />
        </div>
      </div>

      <!-- Order summary -->
      <div class="lg:col-span-1">
        <div class="bg-card border border-border rounded-2xl p-5 sticky top-24">
          <h2 class="text-base font-semibold text-foreground mb-4">Resumen del pedido</h2>

          <div class="space-y-2 text-sm">
            <div class="flex justify-between text-muted-foreground">
              <span>Subtotal ({{ totalQuantity }} productos)</span>
              <span>{{ formatCOP(cart?.totalprice ?? 0) }}</span>
            </div>
            <div class="flex justify-between text-muted-foreground">
              <span>Envío</span>
              <span class="text-green-600 font-medium">Calculado al pagar</span>
            </div>
          </div>

          <div class="border-t border-border my-4" />

          <div class="flex justify-between items-center text-base font-semibold mb-5">
            <span>Total</span>
            <span class="text-primary text-lg">{{ formatCOP(cart?.totalprice ?? 0) }}</span>
          </div>

          <NuxtLink
            to="/checkout"
            class="block w-full h-11 rounded-xl bg-foreground text-background text-sm font-semibold hover:bg-foreground/90 transition-colors flex items-center justify-center gap-2"
          >
            Proceder al pago
            <Icon name="lucide:arrow-right" class="w-4 h-4" />
          </NuxtLink>

          <NuxtLink
            to="/collections/serums"
            class="block w-full text-center text-sm text-muted-foreground hover:text-primary transition-colors mt-3"
          >
            Seguir comprando
          </NuxtLink>
        </div>
      </div>
    </div>

    <!-- Empty cart -->
    <div v-else class="flex flex-col items-center justify-center py-20 text-center">
      <div class="w-20 h-20 rounded-full bg-muted flex items-center justify-center mb-4">
        <Icon name="lucide:shopping-bag" class="w-9 h-9 text-muted-foreground" />
      </div>
      <h2 class="text-xl font-semibold text-foreground mb-2">Tu carrito está vacío</h2>
      <p class="text-sm text-muted-foreground mb-6">Descubre nuestros productos de skincare</p>
      <NuxtLink
        to="/collections/serums"
        class="inline-flex items-center gap-2 h-11 px-8 rounded-full bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors"
      >
        Ver productos
        <Icon name="lucide:arrow-right" class="w-4 h-4" />
      </NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '~/store/cart'

const cartStore = useCartStore()
const { decreaseItemQuantity, increaseItemQuantity, removeCartItem } = cartStore
const { cartItems, cart, totalQuantity } = storeToRefs(cartStore)
const { isMobile } = useUtilities()

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency', currency: 'COP', maximumFractionDigits: 0,
  }).format(value)
}
</script>
