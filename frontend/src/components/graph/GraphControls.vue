<template>
  <div class="graph-controls">
    <button class="gc-btn" @click="$emit('zoomIn')" title="放大">
      <el-icon :size="16"><ZoomIn /></el-icon>
    </button>
    <button class="gc-btn" @click="$emit('zoomOut')" title="缩小">
      <el-icon :size="16"><ZoomOut /></el-icon>
    </button>
    <button class="gc-btn" @click="$emit('fit')" title="适应画布">
      <el-icon :size="16"><FullScreen /></el-icon>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ZoomIn, ZoomOut, FullScreen } from '@element-plus/icons-vue'

defineEmits<{
  zoomIn: []
  zoomOut: []
  fit: []
}>()
</script>

<style lang="scss" scoped>
.graph-controls {
  position: absolute;
  bottom: 16px;
  right: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  z-index: 10;
}

.gc-btn {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-sm);
  background: var(--color-bg-card);
  color: var(--color-text-secondary);
  cursor: pointer;
  transition: all var(--transition-fast);

  &:hover {
    background: var(--color-bg-card-hover);
    color: var(--color-text-primary);
    border-color: var(--color-border-light);
  }
}
</style>
