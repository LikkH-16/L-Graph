<template>
  <div class="app-sidebar">
    <div class="sidebar-header">
      <template v-if="!uiStore.sidebarCollapsed">
        <div class="sidebar-logo">
          <svg width="28" height="28" viewBox="0 0 40 40" fill="none">
            <circle cx="20" cy="12" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
            <circle cx="12" cy="28" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
            <circle cx="28" cy="28" r="6" stroke="#7c5ce7" stroke-width="2.5" fill="none"/>
            <line x1="17" y1="17" x2="14" y2="23" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
            <line x1="23" y1="17" x2="26" y2="23" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
            <line x1="17" y1="30" x2="23" y2="30" stroke="#7c5ce7" stroke-width="1.5" opacity="0.6"/>
          </svg>
          <span class="sidebar-brand">L-Graph</span>
        </div>
      </template>
      <el-tooltip :content="uiStore.sidebarCollapsed ? '展开侧边栏' : '折叠侧边栏'" placement="right">
        <el-button text class="sidebar-toggle" @click="uiStore.toggleSidebar()">
          <el-icon :size="18"><Fold v-if="!uiStore.sidebarCollapsed" /><Expand v-else /></el-icon>
        </el-button>
      </el-tooltip>
    </div>

    <div v-if="!uiStore.sidebarCollapsed" class="sidebar-body">
      <div class="sidebar-subject-selector">
        <span class="sidebar-label">学科</span>
        <el-tooltip content="选择要学习的学科" placement="right">
          <el-select
            v-model="selectedSubject"
            placeholder="选择学科"
            size="small"
            popper-class="sidebar-select-popper"
            @change="onSubjectChange"
          >
            <el-option
              v-for="s in subjectStore.subjects"
              :key="s.id"
              :label="`${s.icon} ${s.name}`"
              :value="s.id"
            />
          </el-select>
        </el-tooltip>
      </div>

      <div class="sidebar-search">
        <el-tooltip content="搜索知识树节点" placement="right">
          <el-input
            v-model="searchText"
            placeholder="搜索知识点..."
            size="small"
            clearable
            :prefix-icon="Search"
          />
        </el-tooltip>
      </div>

      <div class="sidebar-tree" v-loading="treeStore.loading">
        <template v-if="treeStore.treeData.length > 0">
          <KnowledgeTree />
        </template>
        <EmptyState v-else message="选择一个学科以查看知识树" />
      </div>
    </div>

    <div class="sidebar-footer">
      <el-dropdown trigger="click" popper-class="user-dropdown-popper" @command="handleUserCommand">
        <el-button text class="sidebar-user-btn">
          <el-icon :size="18"><UserFilled /></el-icon>
          <span v-if="!uiStore.sidebarCollapsed" class="sidebar-username">
            {{ authStore.user?.username || '用户' }}
          </span>
        </el-button>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="profile">
              <el-icon><User /></el-icon>
              个人信息
            </el-dropdown-item>
            <el-dropdown-item command="settings">
              <el-icon><Tools /></el-icon>
              设置
            </el-dropdown-item>
            <el-dropdown-item divided command="logout">
              <el-icon><SwitchButton /></el-icon>
              退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
      <template v-if="!uiStore.sidebarCollapsed">
        <ThemeToggle />
      </template>
      <template v-else>
        <el-tooltip content="切换主题" placement="right">
          <ThemeToggle />
        </el-tooltip>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Fold, Expand, Search, UserFilled, User, Tools, SwitchButton } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import { useAuthStore } from '@/stores/auth.store'
import { useSubjectStore } from '@/stores/subject.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import KnowledgeTree from '@/components/knowledge-tree/KnowledgeTree.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import ThemeToggle from '@/components/common/ThemeToggle.vue'

const router = useRouter()
const route = useRoute()
const uiStore = useUiStore()
const authStore = useAuthStore()
const subjectStore = useSubjectStore()
const treeStore = useKnowledgeTreeStore()

const selectedSubject = ref<number | null>(null)
const searchText = ref('')

onMounted(async () => {
  await subjectStore.fetchSubjects()
  if (subjectStore.subjects.length > 0) {
    selectedSubject.value = subjectStore.subjects[0].id
    await onSubjectChange(selectedSubject.value)
  }
})

async function onSubjectChange(id: number | null) {
  if (id) {
    subjectStore.setCurrentSubject(id)
    await treeStore.fetchTree(id)
    const currentSubjectId = route.params.subjectId
    if (String(currentSubjectId) !== String(id)) {
      router.push(`/subjects/${id}`)
    }
  }
}

function handleUserCommand(command: string) {
  switch (command) {
    case 'profile':
      // Navigate to profile or show info
      break
    case 'settings':
      // Future settings page
      break
    case 'logout':
      authStore.logout()
      router.push('/login')
      break
  }
}
</script>

<style lang="scss" scoped>
.app-sidebar {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  height: var(--navbar-height);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 var(--space-3);
  border-bottom: 1px solid var(--color-border);
  flex-shrink: 0;
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: var(--space-2);
}

.sidebar-brand {
  font-size: var(--font-size-lg);
  font-weight: 700;
  color: var(--color-text-primary);
  letter-spacing: -0.02em;
}

.sidebar-toggle {
  color: var(--color-text-muted) !important;
  transition: all var(--transition-fast);
  &:hover { color: var(--color-text-primary) !important; background: var(--color-bg-card-hover) !important; }
}

.sidebar-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  padding: var(--space-3);
}

.sidebar-label {
  font-size: var(--font-size-xs);
  font-weight: 600;
  color: var(--color-text-muted);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: var(--space-1);
  display: block;
}

.sidebar-subject-selector {
  margin-bottom: var(--space-3);
}

.sidebar-search {
  margin-bottom: var(--space-3);
}

.sidebar-tree {
  flex: 1;
  overflow-y: auto;
  margin: 0 calc(-1 * var(--space-3));
  padding: 0 var(--space-3);
}

.sidebar-footer {
  flex-shrink: 0;
  padding: var(--space-2) var(--space-3);
  border-top: 1px solid var(--color-border);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.sidebar-user-btn {
  color: var(--color-text-secondary) !important;
  font-size: var(--font-size-sm);
  padding: 6px 8px;
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
  &:hover { color: var(--color-text-primary) !important; background: var(--color-bg-card-hover) !important; }
}

.sidebar-username {
  margin-left: var(--space-2);
}
</style>

<style lang="scss">
// User dropdown popper
.user-dropdown-popper {
  background: var(--color-bg-card) !important;
  border: 1px solid var(--color-border) !important;
  border-radius: var(--radius-md) !important;
  min-width: 150px !important;

  .el-dropdown-menu__item {
    color: var(--color-text-secondary) !important;
    display: flex;
    align-items: center;
    gap: 8px;

    &:hover {
      background: var(--color-bg-card-hover) !important;
      color: var(--color-text-primary) !important;
    }
  }
}

// Subject selector popper
.sidebar-select-popper {
  background: var(--color-bg-card) !important;
  border: 1px solid var(--color-border) !important;

  .el-select-dropdown__item {
    color: var(--color-text-secondary) !important;
    &.selected { color: var(--color-accent-light) !important; }
    &:hover { background: var(--color-bg-card-hover) !important; }
  }
}
</style>
