<template>
  <component :is="layoutComponent || 'div'" style="height: 100%;">
    <router-view v-slot="{ Component }">
      <transition name="page" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
  </component>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import AuthLayout from '@/components/layout/AuthLayout.vue'

const route = useRoute()

const layoutMap: Record<string, unknown> = {
  main: MainLayout,
  auth: AuthLayout,
}

const layoutComponent = computed(() => {
  const layout = route.meta.layout as string | undefined
  if (!layout) return null
  return layoutMap[layout] || null
})
</script>
