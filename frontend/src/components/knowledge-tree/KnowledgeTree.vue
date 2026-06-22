<template>
  <div class="knowledge-tree">
    <el-tree
      ref="treeRef"
      :data="treeStore.treeData"
      :props="treeProps"
      node-key="id"
      :highlight-current="true"
      :expand-on-click-node="true"
      :default-expanded-keys="treeStore.expandedKeys"
      @node-click="onNodeClick"
    >
      <template #default="{ data }">
        <span class="tree-node" :class="getNodeClass(data)">
          <span class="tree-node__dot" :style="{ background: getMasteryColor(data.masteryLevel) }"></span>
          <span class="tree-node__label">{{ data.name }}</span>
          <span v-if="data.pageCount > 0" class="tree-node__count">{{ data.pageCount }}</span>
        </span>
      </template>
    </el-tree>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import type { KnowledgeNodeTreeItem } from '@/types'

const route = useRoute()
const router = useRouter()
const treeStore = useKnowledgeTreeStore()

const treeProps = {
  label: 'name',
  children: 'children',
}

function getMasteryColor(level: number): string {
  const colors: Record<number, string> = {
    0: 'var(--color-mastery-0)',
    1: 'var(--color-mastery-1)',
    2: 'var(--color-mastery-2)',
    3: 'var(--color-mastery-3)',
  }
  return colors[level] || colors[0]
}

function getNodeClass(node: KnowledgeNodeTreeItem) {
  return {
    'tree-node--chapter': node.nodeType === 'CHAPTER',
    'tree-node--section': node.nodeType === 'SECTION',
    'tree-node--topic': node.nodeType === 'TOPIC',
    'tree-node--mastered': node.masteryLevel === 3,
  }
}

function onNodeClick(data: KnowledgeNodeTreeItem) {
  treeStore.selectNode(data.id)
  treeStore.expandNode(data.id)
  // Navigate to subject detail if currently on graph/progress/slides
  // so the content area follows the node selection.
  const subjectId = route.params.subjectId
  if (subjectId && route.name !== 'SubjectDetail') {
    router.push(`/subjects/${subjectId}`)
  }
}
</script>

<style lang="scss" scoped>
.knowledge-tree {
  font-size: var(--font-size-sm);
}

.tree-node {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  flex: 1;
  min-width: 0;
  padding-right: var(--space-2);

  &__dot {
    flex-shrink: 0;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    transition: background var(--transition-normal), box-shadow var(--transition-normal);
  }

  &__label {
    flex: 1;
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  &__count {
    flex-shrink: 0;
    font-size: var(--font-size-xs);
    color: var(--color-text-muted);
    background: var(--color-bg-primary);
    padding: 1px 6px;
    border-radius: var(--radius-full);
  }

  &--chapter &__label {
    font-weight: 600;
    color: var(--color-text-primary);
  }

  &--section &__label {
    font-weight: 500;
  }

  &--mastered &__dot {
    box-shadow: 0 0 6px rgba(46, 204, 113, 0.4);
  }
}
</style>
