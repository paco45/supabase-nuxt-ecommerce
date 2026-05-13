<template>
  <!-- Dropdown / mobile variant -->
  <div v-if="variant === 'dropdown'" class="flex gap-3 p-3 items-center">
    <NuxtLink :to="`/products/${product?.slug}`" class="shrink-0">
      <img
        :src="product?.primaryImage ?? ''"
        :alt="product?.name"
        class="w-20 h-20 rounded-xl object-cover bg-muted"
      />
    </NuxtLink>
    <div class="flex-1 min-w-0">
      <NuxtLink :to="`/products/${product?.slug}`">
        <p class="text-sm font-medium text-foreground line-clamp-2 leading-snug hover:text-primary transition-colors">
          {{ product?.name }}
        </p>
      </NuxtLink>
      <p class="text-xs text-primary font-medium mt-0.5">{{ formatCOP(item.price) }} c/u</p>
      <div class="flex items-center gap-2 mt-2">
        <!-- Quantity controls -->
        <div class="flex items-center border border-border rounded-lg overflow-hidden h-7">
          <button
            class="w-7 flex items-center justify-center hover:bg-muted transition-colors disabled:opacity-40"
            :disabled="item.quantity === 1"
            @click="emit('decreaseQuantity')"
          >
            <Icon name="lucide:minus" class="w-3 h-3" />
          </button>
          <span class="w-7 text-center text-xs font-medium">{{ item.quantity }}</span>
          <button
            class="w-7 flex items-center justify-center hover:bg-muted transition-colors"
            @click="emit('increaseQuantity')"
          >
            <Icon name="lucide:plus" class="w-3 h-3" />
          </button>
        </div>
        <span class="text-sm font-semibold ml-auto">{{ formatCOP(cartItemPrice) }}</span>
      </div>
    </div>
    <button class="shrink-0 p-1 text-muted-foreground hover:text-foreground transition-colors self-start" @click="emit('removeItem')">
      <Icon name="lucide:x" class="w-4 h-4" />
    </button>
  </div>

  <!-- Full / desktop variant (cart page) -->
  <div v-else class="flex items-center gap-6 py-4 border-t border-border">
    <NuxtLink :to="`/products/${product?.slug}`" class="shrink-0">
      <img
        :src="product?.primaryImage ?? ''"
        :alt="product?.name"
        class="w-24 h-24 rounded-xl object-cover bg-muted"
      />
    </NuxtLink>

    <div class="flex-1 min-w-0">
      <NuxtLink :to="`/products/${product?.slug}`">
        <h3 class="text-sm font-semibold text-foreground hover:text-primary transition-colors line-clamp-2">
          {{ product?.name }}
        </h3>
      </NuxtLink>
      <p v-if="product?.skincareCategory" class="text-xs text-primary mt-0.5">{{ product.skincareCategory }}</p>
    </div>

    <!-- Price -->
    <div class="w-28 text-center text-sm font-medium text-foreground">
      {{ formatCOP(item.price) }}
    </div>

    <!-- Quantity -->
    <div class="flex items-center border border-border rounded-lg overflow-hidden h-9">
      <button
        class="w-9 flex items-center justify-center hover:bg-muted transition-colors disabled:opacity-40"
        :disabled="item.quantity === 1"
        @click="emit('decreaseQuantity')"
      >
        <Icon name="lucide:minus" class="w-3.5 h-3.5" />
      </button>
      <span class="w-10 text-center text-sm font-medium">{{ item.quantity }}</span>
      <button
        class="w-9 flex items-center justify-center hover:bg-muted transition-colors"
        @click="emit('increaseQuantity')"
      >
        <Icon name="lucide:plus" class="w-3.5 h-3.5" />
      </button>
    </div>

    <!-- Total -->
    <div class="w-28 text-right text-sm font-semibold text-foreground">
      {{ formatCOP(cartItemPrice) }}
    </div>

    <!-- Remove -->
    <button class="p-1.5 text-muted-foreground hover:text-foreground transition-colors" @click="emit('removeItem')">
      <Icon name="lucide:trash-2" class="w-4 h-4" />
    </button>
  </div>
</template>

<script setup lang="ts">
import type { TablesInsert } from '~/types/database.types'
import { useCart } from '~/composables/cartProduct'

interface Props {
  item: TablesInsert<'cartItems'>
  variant?: 'dropdown' | 'full'
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'full',
})

const emit = defineEmits<{
  (e: 'removeItem' | 'decreaseQuantity' | 'increaseQuantity'): void
}>()

const item = toRef(() => props.item)
const { cartItemPrice, product } = useCart(item)

function formatCOP(value: number) {
  return new Intl.NumberFormat('es-CO', {
    style: 'currency', currency: 'COP', maximumFractionDigits: 0,
  }).format(value)
}
</script>
