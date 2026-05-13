<template>
  <div class="min-h-screen bg-muted/30 flex">
    <!-- Sidebar -->
    <aside
      class="w-64 bg-card border-r border-border flex flex-col fixed h-full z-40 transition-transform duration-200"
      :class="sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'"
    >
      <!-- Logo -->
      <div class="h-16 flex items-center px-6 border-b border-border gap-3">
        <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center">
          <Icon name="lucide:sparkles" class="text-primary w-4 h-4" />
        </div>
        <div>
          <p class="font-heading text-sm font-semibold leading-none">Skin Care</p>
          <p class="text-xs text-muted-foreground mt-0.5">Panel Admin</p>
        </div>
      </div>

      <!-- Nav -->
      <nav class="flex-1 py-4 px-3 space-y-1 overflow-y-auto">
        <p class="text-xs font-medium text-muted-foreground px-3 mb-2 uppercase tracking-wider">Principal</p>
        <NuxtLink
          v-for="item in navItems"
          :key="item.to"
          :to="item.to"
          class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors"
          :class="isActive(item.to)
            ? 'bg-primary/10 text-primary'
            : 'text-foreground/70 hover:bg-muted hover:text-foreground'"
        >
          <Icon :name="item.icon" class="w-4 h-4 shrink-0" />
          {{ item.label }}
          <span
            v-if="item.badge"
            class="ml-auto text-xs bg-destructive text-destructive-foreground rounded-full px-1.5 py-0.5 leading-none"
          >{{ item.badge }}</span>
        </NuxtLink>
      </nav>

      <!-- Footer sidebar -->
      <div class="p-4 border-t border-border">
        <NuxtLink
          to="/"
          class="flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-muted-foreground hover:text-foreground hover:bg-muted transition-colors"
        >
          <Icon name="lucide:store" class="w-4 h-4" />
          Ver tienda
        </NuxtLink>
        <button
          class="w-full flex items-center gap-3 px-3 py-2 rounded-lg text-sm text-muted-foreground hover:text-destructive hover:bg-destructive/10 transition-colors mt-1"
          @click="signOut"
        >
          <Icon name="lucide:log-out" class="w-4 h-4" />
          Cerrar sesión
        </button>
      </div>
    </aside>

    <!-- Overlay mobile -->
    <div
      v-if="sidebarOpen"
      class="fixed inset-0 bg-black/40 z-30 lg:hidden"
      @click="sidebarOpen = false"
    />

    <!-- Main content -->
    <div class="flex-1 lg:ml-64 flex flex-col min-h-screen">
      <!-- Top bar -->
      <header class="h-16 bg-card border-b border-border flex items-center px-6 gap-4 sticky top-0 z-20">
        <button class="lg:hidden" @click="sidebarOpen = !sidebarOpen">
          <Icon name="lucide:menu" class="w-5 h-5" />
        </button>
        <div class="flex-1">
          <h1 class="font-heading text-lg font-semibold">{{ pageTitle }}</h1>
        </div>
        <div class="flex items-center gap-3">
          <span class="text-sm text-muted-foreground hidden sm:block">{{ userEmail }}</span>
          <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center text-xs font-semibold text-primary">
            {{ userInitial }}
          </div>
        </div>
      </header>

      <!-- Page content -->
      <main class="flex-1 p-6">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const supabase = useSupabaseClient()
const user = useSupabaseUser()

const sidebarOpen = ref(false)

const navItems = [
  { to: '/admin', icon: 'lucide:layout-dashboard', label: 'Dashboard' },
  { to: '/admin/productos', icon: 'lucide:package', label: 'Productos' },
  { to: '/admin/ordenes', icon: 'lucide:shopping-bag', label: 'Órdenes' },
  { to: '/admin/categorias', icon: 'lucide:tag', label: 'Categorías' },
  { to: '/admin/inventario', icon: 'lucide:bar-chart-3', label: 'Inventario' },
]

const isActive = (to: string) => {
  if (to === '/admin') return route.path === '/admin'
  return route.path.startsWith(to)
}

const pageTitles: Record<string, string> = {
  '/admin': 'Dashboard',
  '/admin/productos': 'Productos',
  '/admin/ordenes': 'Órdenes',
  '/admin/categorias': 'Categorías',
  '/admin/inventario': 'Inventario',
}

const pageTitle = computed(() => {
  for (const [path, title] of Object.entries(pageTitles)) {
    if (route.path === path || (path !== '/admin' && route.path.startsWith(path))) return title
  }
  return 'Admin'
})

const userEmail = computed(() => user.value?.email ?? '')
const userInitial = computed(() => userEmail.value.charAt(0).toUpperCase())

async function signOut() {
  await supabase.auth.signOut()
  navigateTo('/account/login')
}
</script>
