<template>
  <div class="graph-legend">
    <div class="legend-item">
      <span class="legend-dot" style="background: #3a3a5c;"></span> 未学习
    </div>
    <div class="legend-item">
      <span class="legend-dot" style="background: #e74c3c;"></span> 一轮
    </div>
    <div class="legend-item">
      <span class="legend-dot" style="background: #f39c12;"></span> 二轮
    </div>
    <div class="legend-item">
      <span class="legend-dot" style="background: #2ecc71;"></span> 已掌握
    </div>
  </div>
</template>

<style lang="scss" scoped>
.graph-legend {
  position: absolute;
  bottom: 16px;
  left: 16px;
  display: flex;
  gap: 12px;
  padding: 6px 12px;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  z-index: 10;
  font-size: var(--font-size-xs);
  color: var(--color-text-secondary);
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 4px;
}

.legend-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}
</style>
