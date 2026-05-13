// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },

  modules: [
    '@pinia/nuxt',
    '@nuxtjs/i18n',
    '@vueuse/nuxt',
    'nuxt-lodash',
    '@nuxtjs/tailwindcss',
    '@nuxt/eslint',
    '@nuxtjs/supabase',
    '@nuxt/fonts',
    'shadcn-nuxt',
    '@nuxtjs/color-mode',
    'nuxt-swiper',
    '@pinia-plugin-persistedstate/nuxt',
    'radix-vue/nuxt',
    '@vee-validate/nuxt',
  ],

  supabase: {
    redirect: false,
  },

  tailwindcss: {
    cssPath: ['~/assets/css/tailwind.css', { injectPosition: 'first' }],
    configPath: './tailwind.config.js',
    exposeConfig: {
      level: 2,
    },
    config: {},
    viewer: true,
  },

  shadcn: {
    /**
     * Prefix for all the imported component
     */
    prefix: '',
    /**
     * Directory that the component lives in.
     * @default "./components/ui"
     */
    componentDir: './components/ui',
  },

  colorMode: {
    classSuffix: '',
  },

  css: ['~/assets/css/tailwind.css', '~/assets/scss/main.scss'],
  compatibilityDate: '2024-08-17',
  fonts: {
    provider: 'google',
    families: [
      {
        name: 'Cormorant Garamond',
        provider: 'google',
        subsets: ['latin'],
        display: 'swap',
        weight: [400, 500, 600, 700],
        styles: ['normal', 'italic'],
        fallbacks: ['Georgia', 'serif'],
      },
      {
        name: 'DM Sans',
        provider: 'google',
        subsets: ['latin'],
        display: 'swap',
        weight: [300, 400, 500, 600],
        styles: ['normal'],
        fallbacks: ['Arial', 'sans-serif'],
      },
    ],
  },
  devServer: {
    port: 3000,
    host: '0.0.0.0',
  },
  runtimeConfig: {
    mercadopagoAccessToken: process.env.MERCADOPAGO_ACCESS_TOKEN,
    public: {
      mercadopagoPublicKey: process.env.MERCADOPAGO_PUBLIC_KEY,
    },
  },
})
