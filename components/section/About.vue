<template>
  <section class="py-12 px-4 sm:px-6 lg:px-16">
    <div class="max-w-5xl mx-auto">
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <div
          v-for="item in features"
          :key="item.title"
          class="flex flex-col items-center text-center p-5 rounded-2xl bg-card border border-border hover:border-primary/30 hover:shadow-sm transition-all duration-300 gap-3"
        >
          <div class="w-11 h-11 rounded-full bg-primary/10 flex items-center justify-center shrink-0">
            <Icon :name="item.icon" class="w-5 h-5 text-primary" />
          </div>
          <div>
            <p class="text-sm font-semibold text-foreground leading-snug">{{ item.title }}</p>
            <p class="text-[12px] text-muted-foreground mt-1 leading-relaxed">{{ item.description }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script lang="ts" setup>
const features = [
  {
    title: 'Pago Seguro',
    icon: 'lucide:shield-check',
    description: 'Paga con MercadoPago, tarjeta débito o crédito. Tus datos siempre protegidos.',
  },
  {
    title: 'Atención al Cliente',
    icon: 'lucide:headphones',
    description: 'Resolvemos tus dudas sobre rutinas y productos. Estamos aquí para ayudarte.',
  },
  {
    title: 'Cambios y Devoluciones',
    icon: 'lucide:refresh-cw',
    description: 'Si el producto llega en mal estado, lo cambiamos sin complicaciones.',
  },
  {
    title: 'Envío a Colombia',
    icon: 'lucide:truck',
    description: 'Despachos a todo el territorio colombiano. Seguimiento en tiempo real.',
  },
]
</script>
