<script lang="ts" setup>
const shopLinks = [
  { to: '/collections/serums', label: 'Sérums' },
  { to: '/collections/hidratantes', label: 'Hidratantes' },
  { to: '/collections/proteccion-solar', label: 'Protección Solar' },
  { to: '/collections/mascarillas', label: 'Mascarillas' },
  { to: '/collections/kits', label: 'Kits de rutina' },
]

const supportLinks = [
  { to: '/faq', label: 'Preguntas frecuentes' },
  { to: '/contact', label: 'Contacto' },
  { to: '/shipping', label: 'Envíos y entregas' },
  { to: '/returns', label: 'Cambios y devoluciones' },
]

const accountLinks = [
  { to: '/account/login', label: 'Iniciar sesión' },
  { to: '/account/register', label: 'Registrarse' },
  { to: '/wishlist', label: 'Mis favoritos' },
  { to: '/account/orders', label: 'Mis pedidos' },
]

const socialLinks = [
  { href: 'https://instagram.com', icon: 'lucide:instagram', label: 'Instagram' },
  { href: 'https://facebook.com', icon: 'lucide:facebook', label: 'Facebook' },
  { href: 'mailto:hola@luminaskin.co', icon: 'lucide:mail', label: 'Email' },
]

const expandedSections = ref<Record<string, boolean>>({
  shop: false,
  support: false,
  account: false,
})
</script>

<template>
  <footer class="bg-muted/30 border-t border-border pt-10 pb-6">
    <div class="px-4 sm:px-6 lg:px-16 mx-auto">
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
        <!-- Brand column -->
        <div class="flex flex-col gap-3">
          <CommonAppLogo />
          <p class="text-sm text-muted-foreground leading-relaxed max-w-xs">
            Rutinas de skincare con ingredientes activos clínicamente probados. Para tu mejor piel.
          </p>
          <a href="mailto:hola@luminaskin.co" class="text-sm text-muted-foreground hover:text-primary transition-colors">
            hola@luminaskin.co
          </a>
          <div class="flex gap-1 mt-1">
            <a
              v-for="link in socialLinks"
              :key="link.label"
              :href="link.href"
              target="_blank"
              class="p-2 rounded-full hover:bg-muted transition-colors"
              :aria-label="link.label"
            >
              <Icon :name="link.icon" class="h-4 w-4 text-muted-foreground hover:text-primary transition-colors" />
            </a>
          </div>
        </div>

        <!-- Desktop link columns -->
        <div class="hidden sm:block">
          <p class="text-sm font-semibold text-foreground mb-3">Tienda</p>
          <ul class="flex flex-col gap-2">
            <li v-for="link in shopLinks" :key="link.label">
              <NuxtLink :to="link.to" class="text-sm text-muted-foreground hover:text-primary transition-colors">
                {{ link.label }}
              </NuxtLink>
            </li>
          </ul>
        </div>
        <div class="hidden sm:block">
          <p class="text-sm font-semibold text-foreground mb-3">Soporte</p>
          <ul class="flex flex-col gap-2">
            <li v-for="link in supportLinks" :key="link.label">
              <NuxtLink :to="link.to" class="text-sm text-muted-foreground hover:text-primary transition-colors">
                {{ link.label }}
              </NuxtLink>
            </li>
          </ul>
        </div>
        <div class="hidden sm:block">
          <p class="text-sm font-semibold text-foreground mb-3">Mi cuenta</p>
          <ul class="flex flex-col gap-2">
            <li v-for="link in accountLinks" :key="link.label">
              <NuxtLink :to="link.to" class="text-sm text-muted-foreground hover:text-primary transition-colors">
                {{ link.label }}
              </NuxtLink>
            </li>
          </ul>
        </div>

        <!-- Mobile accordion -->
        <div class="sm:hidden col-span-1">
          <div
            v-for="(section, key) in { shop: { label: 'Tienda', links: shopLinks }, support: { label: 'Soporte', links: supportLinks }, account: { label: 'Mi cuenta', links: accountLinks } }"
            :key="key"
            class="border-b border-border"
          >
            <button
              class="w-full flex justify-between items-center py-3 text-sm font-semibold text-foreground"
              @click="expandedSections[key] = !expandedSections[key]"
            >
              {{ section.label }}
              <Icon :name="expandedSections[key] ? 'lucide:chevron-up' : 'lucide:chevron-down'" class="w-4 h-4" />
            </button>
            <ul v-if="expandedSections[key]" class="pb-3 flex flex-col gap-2">
              <li v-for="link in section.links" :key="link.label">
                <NuxtLink :to="link.to" class="text-sm text-muted-foreground hover:text-primary transition-colors">
                  {{ link.label }}
                </NuxtLink>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <!-- Bottom bar -->
      <div class="mt-8 pt-6 border-t border-border flex flex-col sm:flex-row items-center justify-between gap-2 text-xs text-muted-foreground">
        <p>© {{ new Date().getFullYear() }} LUMINA SKIN. Todos los derechos reservados.</p>
        <div class="flex items-center gap-1">
          <Icon name="lucide:map-pin" class="w-3 h-3" />
          Colombia
        </div>
      </div>
    </div>
  </footer>
</template>
