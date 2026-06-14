<template>
  <div class="slide-controls">
    <button class="sc-btn" @click="$emit('prev')" title="上一页 (←)">
      <el-icon :size="18"><ArrowLeft /></el-icon>
    </button>
    <span class="sc-counter">{{ currentSlide }} / {{ slideCount }}</span>
    <button class="sc-btn" @click="$emit('next')" title="下一页 (→)">
      <el-icon :size="18"><ArrowRight /></el-icon>
    </button>
    <button class="sc-btn sc-btn--exit" @click="$emit('exit')" title="退出 (Esc)">
      <el-icon :size="18"><Close /></el-icon>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ArrowLeft, ArrowRight, Close } from '@element-plus/icons-vue'

defineProps<{
  slideCount: number
  currentSlide: number
}>()

defineEmits<{
  prev: []
  next: []
  exit: []
}>()
</script>

<style lang="scss" scoped>
.slide-controls {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-2) var(--space-4);
  background: rgba(0, 0, 0, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: var(--radius-full);
  z-index: 100;
  backdrop-filter: blur(10px);
}

.sc-btn {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: none;
  border-radius: 50%;
  background: transparent;
  color: #fff;
  cursor: pointer;
  transition: background var(--transition-fast);

  &:hover { background: rgba(255, 255, 255, 0.15); }

  &--exit:hover { background: rgba(231, 76, 60, 0.4); }
}

.sc-counter {
  font-size: var(--font-size-sm);
  color: rgba(255, 255, 255, 0.7);
  min-width: 60px;
  text-align: center;
  font-variant-numeric: tabular-nums;
}
</style>
