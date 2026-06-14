<template>
  <div class="loading-spinner" :class="{ 'is-fullscreen': fullscreen }">
    <div class="loading-spinner__ring"></div>
    <p v-if="text" class="loading-spinner__text">{{ text }}</p>
  </div>
</template>

<script setup lang="ts">
withDefaults(defineProps<{
  text?: string
  fullscreen?: boolean
}>(), {
  fullscreen: false,
})
</script>

<style lang="scss" scoped>
.loading-spinner {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: var(--space-3);
  padding: var(--space-10);

  &.is-fullscreen {
    position: fixed;
    inset: 0;
    background: var(--color-bg-primary);
    z-index: 9999;
  }

  &__ring {
    width: 36px;
    height: 36px;
    border: 3px solid var(--color-border);
    border-top-color: var(--color-accent);
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
  }

  &__text {
    font-size: var(--font-size-sm);
    color: var(--color-text-muted);
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
