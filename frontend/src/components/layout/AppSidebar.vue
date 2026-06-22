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
          <div class="sidebar-tree-actions">
            <el-tooltip content="在当前学科下添加新的知识点节点" placement="right">
              <el-button size="small" text class="add-node-btn" @click="openAddNodeDialog">
                <el-icon :size="14"><Plus /></el-icon>
                添加节点
              </el-button>
            </el-tooltip>
          </div>
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

    <!-- Add node dialog -->
    <el-dialog
      v-model="addNodeDialogVisible"
      title="添加知识点节点"
      width="420px"
      :close-on-click-modal="false"
    >
      <el-form :model="newNodeForm" label-position="top" size="default">
        <el-form-item label="节点名称" required>
          <el-input v-model="newNodeForm.name" placeholder="请输入知识点名称" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="节点类型">
          <el-select v-model="newNodeForm.nodeType" style="width: 100%">
            <el-option label="章节 (Chapter)" value="CHAPTER" />
            <el-option label="小节 (Section)" value="SECTION" />
            <el-option label="主题 (Topic)" value="TOPIC" />
          </el-select>
        </el-form-item>
        <el-form-item label="父节点（可选）">
          <el-tree-select
            v-model="newNodeForm.parentId"
            :data="treeStore.treeData"
            :props="{ label: 'name', children: 'children', value: 'id' }"
            placeholder="选择父节点（留空则创建为根节点）"
            clearable
            check-strictly
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="描述（可选）">
          <el-input v-model="newNodeForm.description" type="textarea" :rows="2" placeholder="简要描述该知识点" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addNodeDialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="addNodeLoading" @click="createKnowledgeNode">确认添加</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, watch, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Fold, Expand, Search, UserFilled, User, Tools, SwitchButton, Plus } from '@element-plus/icons-vue'
import { useUiStore } from '@/stores/ui.store'
import { useAuthStore } from '@/stores/auth.store'
import { useSubjectStore } from '@/stores/subject.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import KnowledgeTree from '@/components/knowledge-tree/KnowledgeTree.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import ThemeToggle from '@/components/common/ThemeToggle.vue'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const uiStore = useUiStore()
const authStore = useAuthStore()
const subjectStore = useSubjectStore()
const treeStore = useKnowledgeTreeStore()

const selectedSubject = ref<number | null>(null)
const searchText = ref('')

// Add node dialog state
const addNodeDialogVisible = ref(false)
const addNodeLoading = ref(false)
const newNodeForm = reactive({
  name: '',
  nodeType: 'TOPIC' as 'CHAPTER' | 'SECTION' | 'TOPIC',
  parentId: null as number | null,
  description: '',
})

onMounted(async () => {
  await subjectStore.fetchSubjects()
  // Sync sidebar selector to the current route (if already on a subject page)
  syncFromRoute()
})

// When the user navigates to a subject (e.g. clicking a card in SubjectListView),
// the sidebar selector and knowledge tree follow automatically.
watch(
  () => route.params.subjectId,
  () => syncFromRoute(),
)

function syncFromRoute() {
  const routeId = route.params.subjectId
  if (routeId) {
    const id = Number(routeId)
    if (selectedSubject.value !== id) {
      selectedSubject.value = id
      subjectStore.setCurrentSubject(id)
      treeStore.fetchTree(id)
    }
  } else {
    // User navigated away from a subject — clear sidebar state
    selectedSubject.value = null
    subjectStore.clearCurrentSubject()
    treeStore.selectNode(null)
    treeStore.treeData = []
  }
}

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

function openAddNodeDialog() {
  newNodeForm.name = ''
  newNodeForm.nodeType = 'TOPIC'
  newNodeForm.parentId = null
  newNodeForm.description = ''
  addNodeDialogVisible.value = true
}

async function createKnowledgeNode() {
  if (!newNodeForm.name.trim()) {
    ElMessage.warning('请输入节点名称')
    return
  }
  if (!selectedSubject.value) {
    ElMessage.warning('请先选择一个学科')
    return
  }
  addNodeLoading.value = true
  try {
    await treeStore.createNode({
      subjectId: selectedSubject.value,
      name: newNodeForm.name.trim(),
      description: newNodeForm.description.trim() || undefined,
      parentId: newNodeForm.parentId,
      nodeType: newNodeForm.nodeType,
    })
    ElMessage.success('知识点节点已添加')
    addNodeDialogVisible.value = false
  } catch {
    ElMessage.error('添加失败')
  } finally {
    addNodeLoading.value = false
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

.sidebar-tree-actions {
  margin-top: var(--space-3);
  padding-top: var(--space-3);
  border-top: 1px solid var(--color-border);
}

.add-node-btn {
  color: var(--color-text-muted) !important;
  font-size: var(--font-size-xs);
  width: 100%;
  justify-content: center;
  &:hover {
    color: var(--color-accent-light) !important;
    background: var(--color-bg-card-hover) !important;
  }
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
