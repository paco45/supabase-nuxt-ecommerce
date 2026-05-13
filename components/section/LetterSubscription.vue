<template>
  <section class="relative overflow-hidden bg-gradient-to-br from-[#fdf6f0] to-[#fce8e4] dark:from-muted dark:to-background border-y border-border py-12 px-4 sm:px-6 lg:px-16">
    <!-- Decorative blobs -->
    <div class="absolute -top-10 -right-10 w-48 h-48 rounded-full bg-primary/10 blur-3xl pointer-events-none" />
    <div class="absolute -bottom-10 -left-10 w-48 h-48 rounded-full bg-accent/50 blur-2xl pointer-events-none" />

    <div class="relative max-w-xl mx-auto text-center">
      <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-medium mb-4">
        <Icon name="lucide:mail" class="w-3.5 h-3.5" />
        Newsletter
      </div>
      <h2 class="font-heading text-3xl sm:text-4xl font-semibold text-foreground mb-2">
        Consejos de skincare <span class="text-primary italic">en tu correo</span>
      </h2>
      <p class="text-sm text-muted-foreground mb-6 leading-relaxed">
        Recibe rutinas personalizadas, novedades de productos y descuentos exclusivos para suscriptores.
      </p>
      <form class="flex flex-col sm:flex-row gap-3" @submit.prevent="handleSubscribe">
        <input
          v-model="email"
          type="email"
          placeholder="tu@correo.com"
          required
          class="flex-1 h-11 px-4 rounded-full border border-border bg-background text-sm focus:outline-none focus:ring-2 focus:ring-primary/30 focus:border-primary transition-colors"
        />
        <button
          type="submit"
          :disabled="submitted"
          class="h-11 px-7 rounded-full bg-primary text-primary-foreground text-sm font-medium hover:bg-primary/90 transition-colors disabled:opacity-70 shrink-0"
        >
          {{ submitted ? '¡Suscrito!' : 'Suscribirme' }}
        </button>
      </form>
      <p class="text-[11px] text-muted-foreground mt-3">
        Sin spam. Cancela cuando quieras.
      </p>
    </div>
  </section>
</template>

<script lang="ts" setup>
const email = ref('')
const submitted = ref(false)

function handleSubscribe() {
  if (!email.value) return
  // TODO: integrate with email provider (e.g., Resend)
  submitted.value = true
  email.value = ''
  setTimeout(() => { submitted.value = false }, 4000)
}
</script>
