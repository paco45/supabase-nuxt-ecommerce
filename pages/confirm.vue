<template>
  <div class="container mx-auto px-4 py-16 max-w-lg text-center">
    <!-- Aprobado -->
    <template v-if="status === 'approved'">
      <div class="w-20 h-20 rounded-full bg-green-100 flex items-center justify-center mx-auto mb-6">
        <Icon name="lucide:check" class="w-10 h-10 text-green-600" />
      </div>
      <h1 class="font-heading text-3xl font-semibold mb-3">¡Pago confirmado!</h1>
      <p class="text-muted-foreground mb-2">
        Tu pedido <strong>#{{ orderId }}</strong> fue recibido y está siendo procesado.
      </p>
      <p class="text-sm text-muted-foreground mb-8">
        Te enviaremos una confirmación cuando tu pedido esté en camino.
      </p>
      <div class="flex flex-col sm:flex-row gap-3 justify-center">
        <NuxtLink to="/" class="h-10 px-6 rounded-xl bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors flex items-center justify-center">
          Seguir comprando
        </NuxtLink>
        <NuxtLink to="/account/orders" class="h-10 px-6 rounded-xl border border-border text-sm font-medium hover:bg-muted transition-colors flex items-center justify-center">
          Ver mis pedidos
        </NuxtLink>
      </div>
    </template>

    <!-- Pendiente -->
    <template v-else-if="status === 'pending' || status === 'in_process'">
      <div class="w-20 h-20 rounded-full bg-amber-100 flex items-center justify-center mx-auto mb-6">
        <Icon name="lucide:clock" class="w-10 h-10 text-amber-600" />
      </div>
      <h1 class="font-heading text-3xl font-semibold mb-3">Pago en proceso</h1>
      <p class="text-muted-foreground mb-2">
        Tu pedido <strong>#{{ orderId }}</strong> está pendiente de confirmación de pago.
      </p>
      <p class="text-sm text-muted-foreground mb-8">
        Si pagaste por Efecty o PSE, puede tardar unas horas. Te notificaremos por email.
      </p>
      <NuxtLink to="/" class="h-10 px-6 rounded-xl bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors inline-flex items-center justify-center">
        Volver a la tienda
      </NuxtLink>
    </template>

    <!-- Rechazado / Error -->
    <template v-else>
      <div class="w-20 h-20 rounded-full bg-red-100 flex items-center justify-center mx-auto mb-6">
        <Icon name="lucide:x" class="w-10 h-10 text-red-600" />
      </div>
      <h1 class="font-heading text-3xl font-semibold mb-3">Algo salió mal</h1>
      <p class="text-muted-foreground mb-8">
        El pago no pudo completarse. Puedes intentarlo de nuevo o elegir otro método de pago.
      </p>
      <NuxtLink to="/checkout" class="h-10 px-6 rounded-xl bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors inline-flex items-center justify-center">
        Intentar de nuevo
      </NuxtLink>
    </template>

    <!-- Detalles técnicos (solo en dev) -->
    <div v-if="isDev && paymentId" class="mt-10 p-4 bg-muted rounded-xl text-left text-xs text-muted-foreground space-y-1">
      <p><strong>payment_id:</strong> {{ paymentId }}</p>
      <p><strong>status:</strong> {{ status }}</p>
      <p><strong>preference_id:</strong> {{ preferenceId }}</p>
      <p><strong>order_id:</strong> {{ orderId }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useCartStore } from '~/store/cart'

const route = useRoute()
const cartStore = useCartStore()

// MercadoPago devuelve estos query params al redirigir
const paymentId = computed(() => route.query.payment_id as string ?? '')
const status = computed(() => route.query.status as string ?? '')
const preferenceId = computed(() => route.query.preference_id as string ?? '')
const orderId = computed(() => route.query.external_reference as string ?? '')

const isDev = process.env.NODE_ENV === 'development'

// Limpiar carrito si el pago fue aprobado
onMounted(() => {
  if (status.value === 'approved') {
    cartStore.cartItems = []
    cartStore.cart = null
  }
})
</script>
