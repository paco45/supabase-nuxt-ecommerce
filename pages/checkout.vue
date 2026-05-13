<template>
  <div class="container mx-auto px-4 py-10 max-w-5xl">
    <h1 class="font-heading text-3xl font-semibold mb-8">Finalizar compra</h1>

    <div class="flex flex-col lg:flex-row gap-8">
      <!-- Columna izquierda: datos de envío -->
      <div class="flex-1 space-y-5">
        <div class="bg-card rounded-xl border border-border p-6 space-y-4">
          <h2 class="font-heading font-semibold text-lg">Datos de envío</h2>

          <div class="grid sm:grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="text-sm font-medium">Nombre completo *</label>
              <input v-model="form.name" type="text" required class="checkout-input w-full" placeholder="María García" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium">Teléfono</label>
              <input v-model="form.phone" type="tel" class="checkout-input w-full" placeholder="+57 300 000 0000" />
            </div>
            <div class="sm:col-span-2 space-y-1.5">
              <label class="text-sm font-medium">Dirección *</label>
              <input v-model="form.address" type="text" required class="checkout-input w-full" placeholder="Calle 123 # 45-67, Apto 8" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium">Ciudad *</label>
              <input v-model="form.city" type="text" required class="checkout-input w-full" placeholder="Bogotá" />
            </div>
            <div class="space-y-1.5">
              <label class="text-sm font-medium">Código postal</label>
              <input v-model="form.zipcode" type="text" class="checkout-input w-full" placeholder="110111" />
            </div>
          </div>
        </div>

        <!-- Método de pago info -->
        <div class="bg-card rounded-xl border border-border p-6">
          <h2 class="font-heading font-semibold text-lg mb-4">Método de pago</h2>
          <div class="flex items-center gap-4 p-4 rounded-lg border-2 border-primary bg-primary/5">
            <div class="w-10 h-10 bg-[#009EE3] rounded-lg flex items-center justify-center shrink-0">
              <span class="text-white font-bold text-xs">MP</span>
            </div>
            <div>
              <p class="font-medium text-sm">MercadoPago</p>
              <p class="text-xs text-muted-foreground">Tarjeta crédito/débito · PSE · Efecty · Baloto</p>
            </div>
            <Icon name="lucide:check-circle" class="w-5 h-5 text-primary ml-auto" />
          </div>
          <p class="text-xs text-muted-foreground mt-3 flex items-center gap-1.5">
            <Icon name="lucide:shield-check" class="w-3.5 h-3.5 text-green-500" />
            Pago seguro procesado por MercadoPago. No almacenamos datos de tu tarjeta.
          </p>
        </div>
      </div>

      <!-- Columna derecha: resumen -->
      <div class="lg:w-80 space-y-4">
        <div class="bg-card rounded-xl border border-border overflow-hidden">
          <div class="p-4 border-b border-border">
            <h2 class="font-heading font-semibold">Resumen del pedido</h2>
          </div>

          <div class="divide-y divide-border">
            <div v-if="!mergedItems.length" class="p-6 text-center text-sm text-muted-foreground">
              Tu carrito está vacío
            </div>
            <div
              v-for="item in mergedItems"
              :key="item.productId"
              class="flex items-center gap-3 p-4"
            >
              <div class="relative shrink-0">
                <img
                  v-if="item.primaryImage"
                  :src="item.primaryImage"
                  :alt="item.name"
                  class="w-12 h-12 rounded-lg object-cover bg-muted"
                />
                <div v-else class="w-12 h-12 rounded-lg bg-muted" />
                <span class="absolute -top-1.5 -right-1.5 w-5 h-5 rounded-full bg-foreground text-background text-xs flex items-center justify-center font-medium">
                  {{ item.quantity }}
                </span>
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-sm font-medium truncate">{{ item.name }}</p>
              </div>
              <p class="text-sm font-medium shrink-0">{{ formatCOP(item.price * item.quantity) }}</p>
            </div>
          </div>

          <div class="p-4 border-t border-border space-y-2">
            <div class="flex justify-between text-sm text-muted-foreground">
              <span>Subtotal</span>
              <span>{{ formatCOP(cart?.totalprice ?? 0) }}</span>
            </div>
            <div class="flex justify-between text-sm text-muted-foreground">
              <span>Envío</span>
              <span class="text-green-600 font-medium">Gratis</span>
            </div>
            <div class="flex justify-between font-semibold text-base pt-2 border-t border-border">
              <span>Total</span>
              <span>{{ formatCOP(cart?.totalprice ?? 0) }}</span>
            </div>
          </div>
        </div>

        <!-- Botón pagar -->
        <button
          :disabled="loading || !mergedItems.length || !form.name || !form.address || !form.city"
          class="w-full h-12 rounded-xl bg-[#009EE3] hover:bg-[#008FD0] text-white font-semibold text-base transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
          @click="handlePay"
        >
          <Icon v-if="loading" name="lucide:loader-2" class="w-5 h-5 animate-spin" />
          <span v-else class="flex items-center gap-2">
            Pagar con
            <span class="font-bold">MercadoPago</span>
          </span>
        </button>

        <p v-if="error" class="text-sm text-destructive text-center">{{ error }}</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useCartStore } from '~/store/cart'

const cartStore = useCartStore()
const { cart, cartItems } = storeToRefs(cartStore)
const supabase = useSupabaseClient()

const loading = ref(false)
const error = ref('')

const form = reactive({
  name: '',
  phone: '',
  address: '',
  city: '',
  zipcode: '',
  country: 'Colombia',
})

// Enriquecer cartItems con datos del producto
const products = ref<any[]>([])

watchEffect(async () => {
  if (!cartItems.value.length) return
  const ids = cartItems.value.map(i => i.productId).filter(Boolean)
  if (!ids.length) return
  const { data } = await supabase
    .from('products')
    .select('id, name, primaryImage')
    .in('id', ids)
  products.value = data ?? []
})

const mergedItems = computed(() =>
  cartItems.value.map(item => ({
    ...item,
    name: products.value.find(p => p.id === item.productId)?.name ?? `Producto #${item.productId}`,
    primaryImage: products.value.find(p => p.id === item.productId)?.primaryImage ?? null,
  }))
)

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency',
    currency: 'COP',
    maximumFractionDigits: 0,
  }).format(value)
}

async function handlePay() {
  error.value = ''
  loading.value = true

  try {
    // 1. Guardar dirección si hay usuario autenticado
    const user = await supabase.auth.getUser()
    let addressId = null

    if (user.data.user) {
      const { data: addr } = await supabase
        .from('addresses')
        .insert({
          userId: user.data.user.id,
          name: form.name,
          address: form.address,
          city: form.city,
          country: form.country,
          zipcode: form.zipcode || '000000',
        })
        .select('id')
        .single()
      addressId = addr?.id ?? null
    }

    // 2. Crear preferencia en MercadoPago
    const res = await $fetch<{
      sandboxInitPoint: string
      initPoint: string
      orderId: number
    }>('/api/mercadopago/create-preference', {
      method: 'POST',
      body: {
        cartItems: mergedItems.value,
        addressId,
      },
    })

    // 3. Redirigir a MercadoPago
    // En pruebas usamos sandboxInitPoint, en producción initPoint
    const redirectUrl = res.sandboxInitPoint ?? res.initPoint
    window.location.href = redirectUrl
  } catch (err: any) {
    error.value = err?.data?.statusMessage ?? 'Ocurrió un error al procesar el pago. Intenta de nuevo.'
    loading.value = false
  }
}
</script>

<style scoped>
.checkout-input {
  @apply h-10 px-3 rounded-lg border border-border bg-background text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 transition-shadow;
}
</style>
