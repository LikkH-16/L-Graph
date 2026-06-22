<template>
  <div class="graph-explorer-view">
    <div class="graph-header">
      <div>
        <div class="graph-header-top">
          <el-tooltip content="返回学科详情" placement="bottom">
            <el-button text class="back-btn" @click="$router.push(`/subjects/${$route.params.subjectId}`)">
              <el-icon :size="18"><ArrowLeft /></el-icon>
              返回
            </el-button>
          </el-tooltip>
        </div>
        <h1 class="graph-title">知识图谱</h1>
        <p class="graph-desc">可视化浏览知识点之间的关联关系。节点颜色表示掌握程度，大小表示笔记数量。</p>
      </div>
      <el-tooltip content="颜色和大小说明" placement="left">
        <el-button text class="legend-toggle" @click="showLegend = !showLegend">
          <el-icon :size="18"><InfoFilled /></el-icon>
        </el-button>
      </el-tooltip>
    </div>

    <!-- Legend panel -->
    <transition name="fade">
      <div v-if="showLegend" class="legend-panel glass-panel">
        <div class="legend-row">
          <span class="legend-dot" style="background: var(--color-mastery-0);"></span>
          <span class="legend-label">灰色 — 未学习</span>
        </div>
        <div class="legend-row">
          <span class="legend-dot" style="background: var(--color-mastery-1);"></span>
          <span class="legend-label">红色 — 一轮复习</span>
        </div>
        <div class="legend-row">
          <span class="legend-dot" style="background: var(--color-mastery-2);"></span>
          <span class="legend-label">橙色 — 二轮复习</span>
        </div>
        <div class="legend-row">
          <span class="legend-dot" style="background: var(--color-mastery-3);"></span>
          <span class="legend-label">绿色 — 已掌握</span>
        </div>
        <div class="legend-divider"></div>
        <div class="legend-row">
          <span class="legend-dot" style="background: transparent; border: 2px dashed var(--color-text-muted);"></span>
          <span class="legend-label">节点大小 = 笔记数量</span>
        </div>
      </div>
    </transition>

    <div v-if="graphStore.loading" class="graph-loading">
      <LoadingSpinner text="正在构建知识图谱..." />
    </div>

    <div v-else class="graph-canvas-wrap">
      <KnowledgeGraph />
    </div>

    <el-drawer
      v-model="showDetail"
      title="节点详情"
      direction="rtl"
      size="360px"
    >
      <template v-if="selectedNodeDetail">
        <h3 class="detail-title">{{ selectedNodeDetail.label }}</h3>
        <el-divider />
        <div class="detail-stat">
          <span class="detail-label">掌握程度</span>
          <el-tooltip :content="masteryText(selectedNodeDetail.masteryLevel)">
            <el-tag :type="masteryTagType(selectedNodeDetail.masteryLevel)" size="small">
              {{ masteryText(selectedNodeDetail.masteryLevel) }}
            </el-tag>
          </el-tooltip>
        </div>
        <div class="detail-stat">
          <span class="detail-label">类型</span>
          <span>{{ selectedNodeDetail.type === 'knowledge' ? '知识点' : '笔记页' }}</span>
        </div>
        <div class="detail-stat" v-if="selectedNodeDetail.reviewRound !== undefined">
          <span class="detail-label">复习轮次</span>
          <span>第 {{ selectedNodeDetail.reviewRound }} 轮</span>
        </div>
        <div v-if="selectedNodeDetail.knowledgeNodeId" class="detail-actions">
          <el-tooltip content="跳转到学科详情并定位该知识点" placement="top">
            <el-button type="primary" size="small" @click="viewNode(selectedNodeDetail.knowledgeNodeId!)">
              <el-icon><View /></el-icon>
              查看相关笔记
            </el-button>
          </el-tooltip>
        </div>
      </template>
    </el-drawer>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { InfoFilled, View, ArrowLeft } from '@element-plus/icons-vue'
import { useGraphStore } from '@/stores/graph.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import { masteryTagType, masteryText } from '@/utils/mastery'
import KnowledgeGraph from '@/components/graph/KnowledgeGraph.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'

const route = useRoute()
const router = useRouter()
const graphStore = useGraphStore()
const treeStore = useKnowledgeTreeStore()
const showDetail = ref(false)
const showLegend = ref(false)

const selectedNodeDetail = computed(() => graphStore.selectedNode)

onMounted(async () => {
  const subjectId = Number(route.params.subjectId)
  await graphStore.fetchGraphData(subjectId)
})

watch(() => graphStore.selectedNodeId, (id) => {
  showDetail.value = !!id
})

function viewNode(nodeId: number) {
  const subjectId = route.params.subjectId
  showDetail.value = false
  // Navigate to subject detail and highlight the tree node
  treeStore.selectNode(nodeId)
  treeStore.expandNode(nodeId)
  router.push(`/subjects/${subjectId}`)
}
</script>

<style lang="scss" scoped>
.graph-explorer-view {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.graph-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  flex-shrink: 0;
}

.graph-header-top {
  margin-bottom: var(--space-2);
}

.back-btn {
  color: var(--color-text-muted) !important;
  padding: 4px 10px;
  &:hover { color: var(--color-accent-light) !important; background: var(--color-bg-card-hover) !important; }
}

.graph-title {
  font-size: var(--font-size-2xl);
  font-weight: 700;
  color: var(--color-text-primary);
  margin-bottom: 2px;
}

.graph-desc {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

.legend-toggle {
  color: var(--color-text-muted) !important;
  &:hover { color: var(--color-text-primary) !important; }
}

.legend-panel {
  position: absolute;
  top: 180px;
  right: 20px;
  z-index: var(--z-overlay);
  padding: var(--space-4);
  min-width: 220px;
}

.legend-row {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  margin-bottom: var(--space-2);

  &:last-child { margin-bottom: 0; }
}

.legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  flex-shrink: 0;
}

.legend-label {
  font-size: var(--font-size-xs);
  color: var(--color-text-secondary);
}

.legend-divider {
  height: 1px;
  background: var(--color-border);
  margin: var(--space-2) 0;
}

.graph-loading {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.graph-canvas-wrap {
  flex: 1;
  min-height: 0;
  position: relative;
}

.detail-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-text-primary);
  margin-bottom: 0;
}

.detail-stat {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-2) 0;
}

.detail-label {
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
}

.detail-actions {
  margin-top: var(--space-4);
  display: flex;
  gap: var(--space-2);
}

.fade-enter-active, .fade-leave-active {
  transition: opacity var(--transition-normal);
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
