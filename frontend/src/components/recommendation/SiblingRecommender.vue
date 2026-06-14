<template>
  <div class="sibling-recommender">
    <h4 class="section-title">
      <el-icon><Connection /></el-icon> 兄弟知识点
    </h4>
    <div v-if="loading" class="skeleton-list">
      <div v-for="i in 2" :key="i" class="skeleton" style="height: 48px; margin-bottom: 8px;"></div>
    </div>
    <div v-else-if="items.length > 0" class="rec-list">
      <div v-for="item in items" :key="item.id" class="rec-card" @click="onClick(item)">
        <div class="rec-card__name">{{ item.knowledgeNodeName }}</div>
        <div class="rec-card__reason">{{ item.reason }}</div>
      </div>
    </div>
    <div v-else class="empty-hint">暂无推荐</div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Connection } from '@element-plus/icons-vue'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import { recommendationApi } from '@/api/recommendation.api'
import type { Recommendation } from '@/types'

const treeStore = useKnowledgeTreeStore()
const items = ref<Recommendation[]>([])
const loading = ref(false)

watch(() => treeStore.selectedNodeId, async (nodeId) => {
  if (!nodeId) { items.value = []; return }
  loading.value = true
  try {
    items.value = await recommendationApi.getSiblings(nodeId)
  } finally {
    loading.value = false
  }
}, { immediate: true })

function onClick(item: Recommendation) {
  if (item.knowledgeNodeId) {
    treeStore.selectNode(item.knowledgeNodeId)
  }
}
</script>

<style lang="scss" scoped>
.section-title {
  font-size: var(--font-size-xs);
  font-weight: 600;
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: var(--space-3);
  display: flex;
  align-items: center;
  gap: 4px;
}

.rec-card {
  padding: var(--space-3);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  margin-bottom: var(--space-2);
  cursor: pointer;
  transition: all var(--transition-fast);

  &:hover {
    border-color: var(--color-border-active);
    background: var(--color-bg-card-hover);
  }

  &__name {
    font-size: var(--font-size-sm);
    font-weight: 500;
    color: var(--color-text-primary);
    margin-bottom: 2px;
  }

  &__reason {
    font-size: var(--font-size-xs);
    color: var(--color-text-muted);
  }
}

.empty-hint { font-size: var(--font-size-xs); color: var(--color-text-muted); text-align: center; padding: var(--space-4); }
</style>
