<template>
  <div class="right-panel">
    <div class="panel-header">
      <h3 class="panel-title">关联知识点</h3>
      <el-tooltip content="关闭面板" placement="left">
        <el-button text size="small" @click="uiStore.toggleRightPanel()">
          <el-icon><Close /></el-icon>
        </el-button>
      </el-tooltip>
    </div>
    <div class="panel-body">
      <div v-if="!treeStore.selectedNodeId" class="empty-hint">
        在左侧知识树中选中一个知识点，这里会显示同级的相关知识点。
      </div>
      <div v-else-if="loading" class="skeleton-list">
        <div v-for="i in 3" :key="i" class="skeleton" style="height:40px;margin-bottom:6px;"></div>
      </div>
      <div v-else-if="siblings.length > 0" class="sibling-list">
        <div
          v-for="sib in siblings"
          :key="sib.id"
          class="sibling-item"
          :class="{ active: sib.id === treeStore.selectedNodeId }"
          @click="jumpToNode(sib.id)"
        >
          <span class="sibling-item__dot" :class="'node-' + sib.nodeType"></span>
          <span class="sibling-item__name">{{ sib.name }}</span>
          <el-tag size="small" :type="sib.nodeType === 'CHAPTER' ? '' : sib.nodeType === 'SECTION' ? 'success' : 'warning'">
            {{ sib.nodeType === 'CHAPTER' ? '章' : sib.nodeType === 'SECTION' ? '节' : '主题' }}
          </el-tag>
        </div>
      </div>
      <div v-else class="empty-hint">当前知识点无同级节点</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Close } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import { knowledgeNodeApi } from '@/api/knowledge-node.api'
import type { KnowledgeNode } from '@/types'

const router = useRouter()
const route = useRoute()
const uiStore = useUiStore()
const treeStore = useKnowledgeTreeStore()

const siblings = ref<KnowledgeNode[]>([])
const loading = ref(false)

watch(() => treeStore.selectedNodeId, async (nodeId) => {
  if (!nodeId) { siblings.value = []; return }
  loading.value = true
  try {
    siblings.value = await knowledgeNodeApi.getSiblings(nodeId)
  } catch {
    siblings.value = []
  } finally {
    loading.value = false
  }
}, { immediate: true })

function jumpToNode(nodeId: number) {
  treeStore.selectNode(nodeId)
  treeStore.expandNode(nodeId)
  const sid = route.params.subjectId
  if (sid) router.push(`/subjects/${sid}`)
}
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
  padding: 0 var(--space-3);
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
  padding: var(--space-3);
}

.sibling-list {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.sibling-item {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-2);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: background var(--transition-fast);

  &:hover { background: var(--color-bg-card-hover); }
  &.active { background: rgba(107, 114, 128, 0.1); }

  &__dot {
    width: 8px; height: 8px;
    border-radius: 50%; flex-shrink: 0;
    &.node-CHAPTER { background: var(--color-accent-light); }
    &.node-SECTION { background: var(--color-success); }
    &.node-TOPIC { background: var(--color-warning); }
  }

  &__name {
    flex: 1;
    font-size: var(--font-size-sm);
    color: var(--color-text-primary);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
}

.empty-hint {
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  text-align: center;
  padding: var(--space-6) var(--space-2);
  line-height: 1.6;
}
</style>
