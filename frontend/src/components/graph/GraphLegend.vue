<template>
  <div class="graph-legend">
    <div class="legend-item">
      <span class="legend-dot" style="background: #6366f1; opacity: 0.65;"></span> 未学习
    </div>
    <div class="legend-item">
      <span class="legend-dot" style="background: #f43f5e;"></span> 一轮复习
    </div>
    <div class="legend-item">
      <span class="legend-dot" style="background: #f59e0b;"></span> 二轮复习
    </div>
    <div class="legend-item">
      <span class="legend-dot mastered"></span> 已掌握
    </div>
  </div>
</template>

<style lang="scss" scoped>
.graph-legend {
  position: absolute;
  bottom: 16px;
  left: 16px;
  display: flex;
  gap: 14px;
  padding: 8px 16px;
  background: rgba(15, 13, 46, 0.85);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: var(--radius-lg);
  z-index: 10;
  font-size: var(--font-size-xs);
  color: #cbd5e1;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;

  &.mastered {
    background: #10b981;
    box-shadow: 0 0 8px rgba(16, 185, 129, 0.5);
  }
}
</style>
