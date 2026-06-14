<template>
  <div class="subject-detail-view">
    <div class="subject-hero" v-if="subjectStore.currentSubject">
      <div class="hero-icon">{{ subjectStore.currentSubject.icon }}</div>
      <div>
        <h1 class="hero-title">{{ subjectStore.currentSubject.name }}</h1>
        <p class="hero-desc">{{ subjectStore.currentSubject.description }}</p>
      </div>
    </div>

    <div v-if="noteStore.loading" class="loading-wrap">
      <LoadingSpinner text="正在加载笔记..." />
    </div>

    <div v-else-if="!noteStore.currentNote" class="empty-note">
      <EmptyState message="尚未创建笔记" icon="📝">
        <el-tooltip content="为当前学科创建第一份笔记">
          <el-button type="primary" @click="createNote" :loading="creating">
            <el-icon><EditPen /></el-icon>
            创建笔记
          </el-button>
        </el-tooltip>
      </EmptyState>
    </div>

    <div v-else class="note-content">
      <div class="page-tabs-bar">
        <div class="page-tabs">
          <el-tooltip
            v-for="page in noteStore.pages"
            :key="page.id"
            :content="`${masteryLabel(page.masteryLevel).text} — 已复习 ${page.reviewRound} 轮`"
            placement="top"
          >
            <button
              class="page-tab"
              :class="{ active: currentPageId === page.id }"
              @click="selectPage(page.id)"
              @contextmenu.prevent="onContextMenu($event, page)"
            >
              <span
                class="page-tab__dot"
                :style="{ background: masteryLabel(page.masteryLevel).hexColor }"
              ></span>
              {{ page.title }}
            </button>
          </el-tooltip>
        </div>
        <el-tooltip content="创建新的笔记页 (Ctrl+N)" placement="top">
          <el-button size="small" type="primary" @click="addPage">
            <el-icon><Plus /></el-icon>
            新建页
          </el-button>
        </el-tooltip>
      </div>

      <div class="editor-area" v-if="currentPage">
        <MarkdownEditor
          :model-value="currentPage.content"
          @update:model-value="onContentChange"
        />
      </div>
    </div>

    <!-- Page context menu -->
    <div
      v-if="contextMenu.visible"
      class="context-menu glass-panel"
      :style="{ left: contextMenu.x + 'px', top: contextMenu.y + 'px' }"
    >
      <button class="context-menu__item" @click="renamePage">
        <el-icon><Edit /></el-icon>
        重命名
      </button>
      <button class="context-menu__item danger" @click="deleteCurrentPage">
        <el-icon><Delete /></el-icon>
        删除页面
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import { Plus, EditPen, Edit, Delete } from '@element-plus/icons-vue'
import { useSubjectStore } from '@/stores/subject.store'
import { useNoteStore } from '@/stores/note.store'
import { usePageStore } from '@/stores/page.store'
import { ElMessage, ElMessageBox } from 'element-plus'
import { masteryLabel } from '@/utils/mastery'
import MarkdownEditor from '@/components/editor/MarkdownEditor.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import EmptyState from '@/components/common/EmptyState.vue'
import type { Page } from '@/types'

const route = useRoute()
const subjectStore = useSubjectStore()
const noteStore = useNoteStore()
const pageStore = usePageStore()

const currentPageId = ref<number | null>(null)
const creating = ref(false)

const contextMenu = ref({
  visible: false,
  x: 0,
  y: 0,
  page: null as Page | null,
})

const currentPage = computed(() => {
  if (!currentPageId.value) return noteStore.pages[0] || null
  return noteStore.pages.find(p => p.id === currentPageId.value) || null
})

onMounted(async () => {
  const subjectId = Number(route.params.subjectId)
  await subjectStore.fetchSubjects()
  subjectStore.setCurrentSubject(subjectId)
  await noteStore.fetchNote(subjectId)
  if (noteStore.pages.length > 0) {
    currentPageId.value = noteStore.pages[0].id
    pageStore.fetchPage(noteStore.pages[0].id)
  }
})

watch(currentPageId, async (id) => {
  if (id) await pageStore.fetchPage(id)
})

// Close context menu on click outside
function onGlobalClick() {
  contextMenu.value.visible = false
}
onMounted(() => document.addEventListener('click', onGlobalClick))
onUnmounted(() => document.removeEventListener('click', onGlobalClick))

function selectPage(id: number) {
  currentPageId.value = id
}

async function addPage() {
  const now = new Date()
  const dateStr = now.toISOString().split('T')[0]
  const title = `${dateStr} 笔记`
  const page = await noteStore.createPage(title)
  if (page) {
    currentPageId.value = page.id
    ElMessage.success('新页面已创建')
  }
}

async function createNote() {
  creating.value = true
  try {
    const subjectId = Number(route.params.subjectId)
    const subject = subjectStore.currentSubject
    await noteStore.createNote(subjectId, `${subject?.name || '新'}笔记`)
    ElMessage.success('笔记已创建')
  } catch {
    ElMessage.error('创建失败')
  } finally {
    creating.value = false
  }
}

function onContentChange(value: string) {
  if (currentPage.value) {
    pageStore.content = value
    pageStore.markDirty()
  }
}

// Context menu handlers
function onContextMenu(e: MouseEvent, page: Page) {
  contextMenu.value = {
    visible: true,
    x: e.clientX,
    y: e.clientY,
    page,
  }
}

async function renamePage() {
  const page = contextMenu.value.page
  if (!page) return
  contextMenu.value.visible = false
  try {
    const { value } = await ElMessageBox.prompt('请输入新名称', '重命名页面', {
      inputValue: page.title,
      confirmButtonText: '确定',
      cancelButtonText: '取消',
    })
    if (value && value.trim()) {
      await pageStore.updatePage(page.id, { title: value.trim() })
      page.title = value.trim()
      ElMessage.success('已重命名')
    }
  } catch {
    // cancelled
  }
}

async function deleteCurrentPage() {
  const page = contextMenu.value.page
  if (!page) return
  contextMenu.value.visible = false
  try {
    await ElMessageBox.confirm(`确定要删除"${page.title}"吗？此操作不可撤销。`, '确认删除', {
      type: 'warning',
      confirmButtonText: '删除',
    })
    await pageStore.deletePage(page.id)
    noteStore.pages = noteStore.pages.filter(p => p.id !== page.id)
    if (currentPageId.value === page.id) {
      currentPageId.value = noteStore.pages[0]?.id || null
    }
    ElMessage.success('已删除')
  } catch {
    // cancelled
  }
}
</script>

<style lang="scss" scoped>
.subject-detail-view {
  max-width: 1100px;
  margin: 0 auto;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.subject-hero {
  display: flex;
  align-items: center;
  gap: var(--space-4);
  margin-bottom: var(--space-6);
  padding: var(--space-5);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
}

.hero-icon { font-size: 2.5rem; }
.hero-title { font-size: var(--font-size-2xl); font-weight: 700; color: var(--color-text-primary); margin-bottom: 2px; }
.hero-desc { font-size: var(--font-size-sm); color: var(--color-text-secondary); }

.page-tabs-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  padding-bottom: var(--space-3);
  border-bottom: 1px solid var(--color-border);
}

.page-tabs {
  display: flex;
  gap: var(--space-1);
  flex-wrap: wrap;
}

.page-tab {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 5px 12px;
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  background: transparent;
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  cursor: pointer;
  transition: all var(--transition-fast);
  user-select: none;

  &:hover {
    border-color: var(--color-border-light);
    color: var(--color-text-primary);
    background: var(--color-bg-card-hover);
  }

  &.active {
    background: rgba(124, 92, 231, 0.12);
    border-color: var(--color-accent);
    color: var(--color-accent-light);
    box-shadow: 0 0 8px rgba(124, 92, 231, 0.1);
  }

  &__dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    flex-shrink: 0;
  }
}

.editor-area {
  flex: 1;
  min-height: 0;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
}

.loading-wrap, .empty-note {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-12) 0;
}

// Context menu
.context-menu {
  position: fixed;
  z-index: var(--z-overlay);
  min-width: 160px;
  padding: var(--space-1);
  box-shadow: var(--shadow-lg);

  &__item {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    width: 100%;
    padding: var(--space-2) var(--space-3);
    border: none;
    background: transparent;
    color: var(--color-text-secondary);
    font-size: var(--font-size-sm);
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all var(--transition-fast);

    &:hover {
      background: var(--color-bg-card-hover);
      color: var(--color-text-primary);
    }

    &.danger:hover {
      background: rgba(231, 76, 60, 0.1);
      color: var(--color-danger);
    }
  }
}
</style>
