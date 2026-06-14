<template>
  <button class="theme-toggle" @click="toggle" :title="isDark ? '切换到亮色模式' : '切换到暗色模式'">
    <el-icon :size="16"><Sunny v-if="!isDark" /><Moon v-else /></el-icon>
  </button>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Sunny, Moon } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'

const uiStore = useUiStore()
const isDark = computed(() => uiStore.theme === 'dark')

function toggle() {
  uiStore.setTheme(isDark.value ? 'light' : 'dark')
}
</script>

<style lang="scss" scoped>
.theme-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: var(--radius-md);
  background: transparent;
  color: var(--color-text-muted);
  cursor: pointer;
  transition: all var(--transition-fast);

  &:hover {
    background: var(--color-bg-card-hover);
    color: var(--color-text-primary);
  }
}
</style>
