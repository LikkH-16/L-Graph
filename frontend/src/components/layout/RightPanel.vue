<template>
  <div class="right-panel">
    <div class="panel-header">
      <h3 class="panel-title">关联推荐</h3>
      <el-tooltip content="关闭推荐面板" placement="left">
        <el-button text size="small" @click="uiStore.toggleRightPanel()">
          <el-icon><Close /></el-icon>
        </el-button>
      </el-tooltip>
    </div>
    <div class="panel-body">
      <SiblingRecommender />
      <MistakeRecommender />
    </div>
  </div>
</template>

<script setup lang="ts">
import { Close } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import SiblingRecommender from '@/components/recommendation/SiblingRecommender.vue'
import MistakeRecommender from '@/components/recommendation/MistakeRecommender.vue'

const uiStore = useUiStore()
</script>

<style lang="scss" scoped>
.right-panel {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.panel-header {
  height: var(--navbar-height);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--space-4);
  border-bottom: 1px solid var(--color-border);
  flex-shrink: 0;
}

.panel-title {
  font-size: var(--font-size-sm);
  font-weight: 600;
  color: var(--color-text-secondary);
}

.panel-body {
  flex: 1;
  overflow-y: auto;
  padding: var(--space-4);
}
</style>
