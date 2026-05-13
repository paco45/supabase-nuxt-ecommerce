<template>
  <section class="px-4 sm:px-6 lg:px-16 py-10">
    <div class="max-w-6xl mx-auto space-y-12">
      <CategoryCarousel
        v-for="id in HOME_PAGE_CATEGORIES_ID"
        :key="id"
        :category-id="id"
      />
    </div>
  </section>
</template>

<script setup lang="ts">
// 3 = Sérums, 4 = Hidratantes, 5 = Protección Solar
const HOME_PAGE_CATEGORIES_ID = [3, 4, 5]
</script>
