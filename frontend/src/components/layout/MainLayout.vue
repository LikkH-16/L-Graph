<template>
  <div class="main-layout" :class="{ 'sidebar-collapsed': uiStore.sidebarCollapsed }">
    <aside class="main-layout__sidebar" :style="{ width: sidebarWidth }">
      <AppSidebar />
    </aside>
    <div class="main-layout__center">
      <nav class="main-layout__navbar">
        <AppNavbar />
      </nav>
      <main class="main-layout__content">
        <slot>
          <transition name="page" mode="out-in">
            <router-view />
          </transition>
        </slot>
      </main>
      <footer class="main-layout__status-bar">
        <el-tooltip v-if="pageCount > 0" content="当前学科的笔记页总数" placement="top">
          <span class="status-bar__item">
            <el-icon :size="12"><Document /></el-icon>
            {{ pageCount }} 页
          </span>
        </el-tooltip>
        <span v-else></span>
        <el-tooltip :content="statusTooltip" placement="top">
          <span class="status-bar__item" :class="statusClass">
            <span class="status-dot" :class="statusClass"></span>
            {{ statusText }}
          </span>
        </el-tooltip>
      </footer>
    </div>
    <transition name="slide-right">
      <aside v-if="uiStore.rightPanelVisible" class="main-layout__right-panel">
        <RightPanel />
      </aside>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Document } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import { useNoteStore } from '@/stores/note.store'
import { usePageStore } from '@/stores/page.store'
import AppSidebar from './AppSidebar.vue'
import AppNavbar from './AppNavbar.vue'
import RightPanel from './RightPanel.vue'

const uiStore = useUiStore()
const noteStore = useNoteStore()
const pageStore = usePageStore()

const sidebarWidth = computed(() =>
  uiStore.sidebarCollapsed ? '64px' : '280px'
)

const pageCount = computed(() => noteStore.pages.length)

const statusText = computed(() => {
  if (pageStore.saving) return '保存中...'
  if (pageStore.isDirty) return '未保存的更改'
  return '已保存'
})

const statusTooltip = computed(() => {
  if (pageStore.saving) return '正在保存笔记内容...'
  if (pageStore.isDirty) return '有未保存的更改，请及时保存 (Ctrl+S)'
  return '所有更改已保存到服务器'
})

const statusClass = computed(() => ({
  'status-saving': pageStore.saving,
  'status-dirty': pageStore.isDirty && !pageStore.saving,
  'status-saved': !pageStore.saving && !pageStore.isDirty,
}))
</script>

<style lang="scss" scoped>
.main-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: var(--color-bg-primary);

  &__sidebar {
    flex-shrink: 0;
    height: 100vh;
    border-right: 1px solid var(--color-border);
    background: var(--color-bg-secondary);
    transition: width var(--transition-normal);
    overflow: hidden;
  }

  &__center {
    flex: 1;
    display: flex;
    flex-direction: column;
    min-width: 0;
    height: 100vh;
  }

  &__navbar {
    flex-shrink: 0;
    height: var(--navbar-height);
    border-bottom: 1px solid var(--color-border);
    background: var(--color-bg-secondary);
  }

  &__content {
    flex: 1;
    overflow-y: auto;
    overflow-x: hidden;
    padding: var(--space-6);
  }

  &__status-bar {
    flex-shrink: 0;
    height: var(--status-bar-height);
    border-top: 1px solid var(--color-border);
    background: var(--color-bg-secondary);
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 var(--space-4);
    font-size: var(--font-size-xs);
    color: var(--color-text-muted);
  }

  &__right-panel {
    flex-shrink: 0;
    width: var(--right-panel-width);
    height: 100vh;
    border-left: 1px solid var(--color-border);
    background: var(--color-bg-secondary);
    overflow-y: auto;
  }
}

.status-bar__item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  cursor: default;
}

.status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  display: inline-block;

  &.status-saving {
    background: var(--color-warning);
    animation: pulse 1s infinite;
  }
  &.status-dirty { background: var(--color-danger); }
  &.status-saved { background: var(--color-success); }
}

@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}
</style>
