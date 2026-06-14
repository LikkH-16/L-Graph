<template>
  <div class="app-navbar">
    <div class="navbar-left">
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/subjects' }">
          <el-tooltip content="返回学科列表" placement="bottom">
            <span class="breadcrumb-home"><el-icon><HomeFilled /></el-icon></span>
          </el-tooltip>
        </el-breadcrumb-item>
        <el-breadcrumb-item v-if="subjectStore.currentSubject">
          {{ subjectStore.currentSubject.icon }} {{ subjectStore.currentSubject.name }}
        </el-breadcrumb-item>
        <el-breadcrumb-item v-if="treeStore.selectedNode">
          {{ treeStore.selectedNode.name }}
        </el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <div class="navbar-center" v-if="showViewTabs">
      <div class="view-tabs">
        <el-tooltip
          v-for="tab in tabs"
          :key="tab.key"
          :content="tab.tooltip"
          placement="bottom"
        >
          <button
            class="view-tab"
            :class="{ active: uiStore.viewMode === tab.key }"
            @click="onTabClick(tab.key)"
          >
            <el-icon :size="15"><component :is="tab.icon" /></el-icon>
            <span>{{ tab.label }}</span>
          </button>
        </el-tooltip>
      </div>
    </div>

    <div class="navbar-right">
      <el-tooltip content="切换侧边栏 (Ctrl+B)" placement="bottom">
        <el-button text @click="uiStore.toggleSidebar()" class="navbar-action">
          <el-icon :size="18"><Expand v-if="uiStore.sidebarCollapsed" /><Fold v-else /></el-icon>
        </el-button>
      </el-tooltip>
      <el-tooltip content="关联推荐面板" placement="bottom">
        <el-button text @click="uiStore.toggleRightPanel()" class="navbar-action">
          <el-icon :size="18"><Connection /></el-icon>
        </el-button>
      </el-tooltip>
      <el-tooltip v-if="authStore.isAdmin" content="管理后台" placement="bottom">
        <el-button
          text
          class="navbar-action"
          @click="$router.push('/admin')"
        >
          <el-icon :size="18"><Setting /></el-icon>
        </el-button>
      </el-tooltip>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { HomeFilled, Expand, Fold, Connection, Setting, Document, Share, DataBoard, TrendCharts } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import { useAuthStore } from '@/stores/auth.store'
import { useSubjectStore } from '@/stores/subject.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import type { ViewMode } from '@/stores/ui.store'

const route = useRoute()
const router = useRouter()
const uiStore = useUiStore()
const authStore = useAuthStore()
const subjectStore = useSubjectStore()
const treeStore = useKnowledgeTreeStore()

const showViewTabs = computed(() => {
  return route.name === 'SubjectDetail' || route.name === 'NoteEditor'
})

const tabs = [
  { key: 'edit' as ViewMode, label: '编辑', icon: Document, tooltip: '笔记编辑模式 — 编写和整理笔记内容' },
  { key: 'graph' as ViewMode, label: '图谱', icon: Share, tooltip: '知识图谱 — 可视化浏览知识点关联关系' },
  { key: 'slides' as ViewMode, label: '演示', icon: DataBoard, tooltip: '演示模式 — 将笔记渲染为交互式幻灯片' },
  { key: 'progress' as ViewMode, label: '进度', icon: TrendCharts, tooltip: '学习进度 — 追踪复习轨迹与掌握程度' },
]

function onTabClick(key: ViewMode) {
  uiStore.setViewMode(key)
  const subjectId = route.params.subjectId
  if (key === 'graph') {
    router.push(`/subjects/${subjectId}/graph`)
  } else if (key === 'slides') {
    router.push(`/subjects/${subjectId}/slides`)
  } else if (key === 'progress') {
    router.push(`/review/${subjectId}`)
  } else {
    router.push(`/subjects/${subjectId}`)
  }
}
</script>

<style lang="scss" scoped>
.app-navbar {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--space-4);
}

.navbar-left {
  flex: 1;
  min-width: 0;
}

.breadcrumb-home {
  display: inline-flex;
  align-items: center;
  padding: 2px 6px;
  border-radius: var(--radius-sm);
  transition: background var(--transition-fast);

  &:hover {
    background: var(--color-bg-card-hover);
  }
}

.navbar-center {
  display: flex;
  justify-content: center;
}

.view-tabs {
  display: flex;
  gap: 2px;
  background: var(--color-bg-primary);
  border-radius: var(--radius-md);
  padding: 2px;
}

.view-tab {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 4px 12px;
  border: none;
  background: transparent;
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all var(--transition-fast);
  white-space: nowrap;

  &:hover {
    color: var(--color-text-secondary);
    background: rgba(124, 92, 231, 0.06);
  }

  &.active {
    background: var(--color-accent);
    color: #fff;
    box-shadow: 0 2px 6px rgba(124, 92, 231, 0.3);
  }
}

.navbar-right {
  flex: 1;
  display: flex;
  justify-content: flex-end;
  gap: var(--space-1);
}

.navbar-action {
  color: var(--color-text-muted) !important;
  transition: all var(--transition-fast);

  &:hover {
    color: var(--color-text-primary) !important;
    background: var(--color-bg-card-hover) !important;
  }
}
</style>
