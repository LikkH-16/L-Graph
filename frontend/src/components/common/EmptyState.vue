<template>
  <div class="empty-state">
    <div class="empty-state__icon">{{ icon }}</div>
    <p class="empty-state__message">{{ message }}</p>
    <slot />
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  message: string
  icon?: string
}>(), {
  icon: '📭',
})
</script>

<style lang="scss" scoped>
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: var(--space-10) var(--space-4);
  text-align: center;

  &__icon { font-size: 2.5rem; margin-bottom: var(--space-3); }
  &__message { color: var(--color-text-muted); font-size: var(--font-size-sm); }
}
</style>
