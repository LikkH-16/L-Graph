<template>
  <div class="page-editor-view">
    <div class="page-editor-header">
      <el-tooltip content="返回学科笔记列表" placement="bottom">
        <el-button text @click="$router.back()">
          <el-icon><ArrowLeft /></el-icon>
          返回
        </el-button>
      </el-tooltip>
      <div class="page-meta" v-if="pageStore.currentPage">
        <h2>{{ pageStore.currentPage.title }}</h2>
        <div class="node-tags">
          <el-tooltip
            v-for="nodeId in pageStore.attachedNodeIds"
            :key="nodeId"
            :content="getNodePath(nodeId)"
            placement="top"
          >
            <el-tag
              size="small"
              type="info"
              closable
              @close="detachNode(nodeId)"
            >
              {{ treeStore.flatNodeMap.get(nodeId)?.name || `节点 #${nodeId}` }}
            </el-tag>
          </el-tooltip>
          <el-tooltip content="将当前页面关联到知识树中的知识点，支持多对多关联" placement="top">
            <el-button size="small" text @click="showAttachPanel = !showAttachPanel">
              <el-icon><Plus /></el-icon>
              挂载知识点
            </el-button>
          </el-tooltip>
        </div>
      </div>
      <div class="page-editor-actions">
        <el-tooltip content="保存当前页面 (Ctrl+S)" placement="bottom">
          <el-button
            type="primary"
            size="small"
            :loading="pageStore.saving"
            :disabled="!pageStore.isDirty"
            @click="savePage"
          >
            <el-icon><Check /></el-icon>
            保存
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <div class="page-editor-body">
      <MarkdownEditor
        v-if="pageStore.currentPage"
        :model-value="pageStore.content"
        @update:model-value="onContentChange"
      />
    </div>

    <!-- Attach panel -->
    <el-dialog v-model="showAttachPanel" title="挂载到知识点" width="520px">
      <div class="attach-search">
        <el-input
          v-model="filterText"
          placeholder="搜索知识点..."
          size="small"
          clearable
          :prefix-icon="Search"
        />
      </div>
      <el-tree
        ref="treeRef"
        :data="treeStore.treeData"
        :props="{ label: 'name', children: 'children' }"
        :filter-node-method="filterNode"
        node-key="id"
        show-checkbox
        :default-checked-keys="pageStore.attachedNodeIds"
        default-expand-all
        @check="onCheckChange"
      />
      <template #footer>
        <el-button @click="showAttachPanel = false">取消</el-button>
        <el-tooltip content="保存知识点关联" placement="top">
          <el-button type="primary" @click="saveAttachments" :loading="attaching">保存关联</el-button>
        </el-tooltip>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { ArrowLeft, Plus, Check, Search } from '@element-plus/icons-vue'
import { usePageStore } from '@/stores/page.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import { useSubjectStore } from '@/stores/subject.store'
import { ElMessage } from 'element-plus'
import type { KnowledgeNode } from '@/types'
import MarkdownEditor from '@/components/editor/MarkdownEditor.vue'

const route = useRoute()
const pageStore = usePageStore()
const treeStore = useKnowledgeTreeStore()
const subjectStore = useSubjectStore()

const showAttachPanel = ref(false)
const attaching = ref(false)
const selectedNodes = ref<number[]>([])
const filterText = ref('')
const treeRef = ref<any>(null)

onMounted(async () => {
  const pageId = Number(route.params.pageId)
  await pageStore.fetchPage(pageId)
  if (pageStore.currentPage?.attachedNodeIds) {
    selectedNodes.value = [...pageStore.currentPage.attachedNodeIds]
  }
  // Load knowledge tree if not already loaded
  if (pageStore.currentPage?.noteId) {
    // We need the subject context for the tree
    const subjectId = Number(route.params.subjectId)
    if (treeStore.treeData.length === 0) {
      await treeStore.fetchTree(subjectId)
    }
  }
})

watch(filterText, (val) => {
  treeRef.value?.filter(val)
})

function filterNode(value: string, data: KnowledgeNode): boolean {
  if (!value) return true
  return data.name.toLowerCase().includes(value.toLowerCase())
}

function getNodePath(nodeId: number): string {
  // Build a simple path from the flat map
  const node = treeStore.flatNodeMap.get(nodeId)
  if (!node) return `节点 #${nodeId}`
  const parts: string[] = [node.name]
  let parentId = node.parentId
  while (parentId) {
    const parent = treeStore.flatNodeMap.get(parentId)
    if (!parent) break
    parts.unshift(parent.name)
    parentId = parent.parentId
  }
  return parts.join(' > ')
}

function onContentChange(value: string) {
  pageStore.content = value
  pageStore.markDirty()
}

async function savePage() {
  if (!pageStore.currentPage) return
  try {
    await pageStore.updatePage(pageStore.currentPage.id, {
      content: pageStore.content,
    })
    pageStore.clearDirty()
    ElMessage.success('已保存')
  } catch {
    ElMessage.error('保存失败')
  }
}

function onCheckChange(_node: unknown, data: { checkedKeys: number[] }) {
  selectedNodes.value = data.checkedKeys
}

async function saveAttachments() {
  attaching.value = true
  try {
    for (const nodeId of selectedNodes.value) {
      if (!pageStore.attachedNodeIds.includes(nodeId)) {
        await pageStore.attachToNode(nodeId)
      }
    }
    for (const nodeId of pageStore.attachedNodeIds) {
      if (!selectedNodes.value.includes(nodeId)) {
        await pageStore.detachFromNode(nodeId)
      }
    }
    ElMessage.success('知识点挂载已更新')
    showAttachPanel.value = false
  } catch {
    ElMessage.error('更新失败')
  } finally {
    attaching.value = false
  }
}

async function detachNode(nodeId: number) {
  await pageStore.detachFromNode(nodeId)
  ElMessage.success('已解除关联')
}
</script>

<style lang="scss" scoped>
.page-editor-view {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.page-editor-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  margin-bottom: var(--space-4);
  gap: var(--space-4);
}

.page-meta {
  flex: 1;
  min-width: 0;
}

.page-meta h2 {
  font-size: var(--font-size-xl);
  font-weight: 600;
  color: var(--color-text-primary);
  margin-bottom: var(--space-2);
}

.page-editor-actions {
  flex-shrink: 0;
  padding-top: 2px;
}

.node-tags {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  flex-wrap: wrap;
}

.attach-search {
  margin-bottom: var(--space-3);
}

.page-editor-body {
  flex: 1;
  min-height: 0;
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  overflow: hidden;
}
</style>
