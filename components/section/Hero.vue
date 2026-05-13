<template>
  <section class="overflow-hidden">
    <!-- Hero principal -->
    <div class="relative min-h-[480px] lg:min-h-[580px] flex items-center bg-gradient-to-br from-[#fdf6f0] to-[#fce8e4] dark:from-background dark:to-muted">
      <!-- Fondo decorativo -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-20 -right-20 w-96 h-96 rounded-full bg-primary/10 blur-3xl" />
        <div class="absolute -bottom-10 -left-10 w-64 h-64 rounded-full bg-accent/40 blur-2xl" />
      </div>

      <div class="container mx-auto px-4 sm:px-6 lg:px-16 relative z-10">
        <div class="grid lg:grid-cols-2 gap-10 items-center">
          <!-- Texto -->
          <div class="space-y-6 text-center lg:text-left">
            <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-primary/10 text-primary text-xs font-medium">
              <Icon name="lucide:sparkles" class="w-3.5 h-3.5" />
              Skincare con ingredientes activos
            </div>
            <h1 class="font-heading text-4xl sm:text-5xl lg:text-6xl font-semibold leading-tight text-foreground">
              Tu mejor piel<br />
              <span class="text-primary italic">empieza aquí</span>
            </h1>
            <p class="text-muted-foreground text-base sm:text-lg leading-relaxed max-w-md mx-auto lg:mx-0">
              Rutinas de skincare con activos clínicamente probados. Vitamina C, Retinol, Ácido Hialurónico y más para resultados reales.
            </p>
            <div class="flex flex-col sm:flex-row gap-3 justify-center lg:justify-start">
              <NuxtLink
                to="/collections/serums"
                class="inline-flex items-center justify-center gap-2 h-12 px-8 rounded-full bg-primary text-primary-foreground font-medium hover:bg-primary/90 transition-colors text-sm"
              >
                Explorar productos
                <Icon name="lucide:arrow-right" class="w-4 h-4" />
              </NuxtLink>
              <NuxtLink
                to="/collections/kits"
                class="inline-flex items-center justify-center h-12 px-8 rounded-full border border-border text-foreground hover:bg-muted transition-colors text-sm font-medium"
              >
                Ver kits de rutina
              </NuxtLink>
            </div>
            <!-- Trust badges -->
            <div class="flex items-center gap-6 justify-center lg:justify-start pt-2">
              <div class="flex items-center gap-1.5 text-xs text-muted-foreground">
                <Icon name="lucide:shield-check" class="w-4 h-4 text-green-500" />
                Dermatológicamente probado
              </div>
              <div class="flex items-center gap-1.5 text-xs text-muted-foreground">
                <Icon name="lucide:truck" class="w-4 h-4 text-primary" />
                Envío a toda Colombia
              </div>
            </div>
          </div>

          <!-- Imagen hero -->
          <div class="relative flex justify-center lg:justify-end">
            <div class="relative w-72 h-72 sm:w-96 sm:h-96 lg:w-[440px] lg:h-[440px]">
              <div class="absolute inset-0 rounded-full bg-primary/10" />
              <img
                src="https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800&q=90"
                alt="Skincare products"
                class="w-full h-full object-cover rounded-full"
              />
              <!-- Floating cards -->
              <div class="absolute -left-6 top-1/4 bg-card border border-border rounded-xl px-3 py-2 shadow-md hidden sm:flex items-center gap-2">
                <div class="w-8 h-8 rounded-full bg-amber-100 flex items-center justify-center text-sm">✨</div>
                <div>
                  <p class="text-xs font-semibold leading-none">Vitamina C 15%</p>
                  <p class="text-[10px] text-muted-foreground mt-0.5">Activo estrella</p>
                </div>
              </div>
              <div class="absolute -right-4 bottom-1/4 bg-card border border-border rounded-xl px-3 py-2 shadow-md hidden sm:flex items-center gap-2">
                <div class="w-8 h-8 rounded-full bg-rose-100 flex items-center justify-center text-sm">🌸</div>
                <div>
                  <p class="text-xs font-semibold leading-none">SPF 50+</p>
                  <p class="text-[10px] text-muted-foreground mt-0.5">Protección diaria</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Banda de ingredientes activos -->
    <div class="border-y border-border bg-muted/30 py-3 overflow-hidden">
      <div class="flex gap-8 items-center animate-scroll whitespace-nowrap">
        <span v-for="ingredient in [...ingredients, ...ingredients]" :key="Math.random()" class="inline-flex items-center gap-2 text-sm text-muted-foreground shrink-0">
          <span class="text-primary">✦</span>
          {{ ingredient }}
        </span>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
const ingredients = [
  'Vitamina C', 'Retinol', 'Ácido Hialurónico', 'Niacinamida',
  'SPF 50+', 'Péptidos', 'Ceramidas', 'AHA/BHA',
  'Centella Asiática', 'Cafeína', 'Escualano', 'Bakuchiol',
]
</script>

<style scoped>
@keyframes scroll {
  from { transform: translateX(0) }
  to { transform: translateX(-50%) }
}
.animate-scroll {
  animation: scroll 20s linear infinite;
  width: max-content;
}
</style>
