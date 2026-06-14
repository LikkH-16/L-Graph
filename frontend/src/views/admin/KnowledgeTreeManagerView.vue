<template>
  <div class="kt-manager">
    <div class="kt-header">
      <h2>知识树管理</h2>
      <div class="kt-header__actions">
        <el-select v-model="subjectFilter" placeholder="选择学科" size="small" style="width: 180px" @change="onSubjectChange">
          <el-option
            v-for="s in subjectStore.subjects"
            :key="s.id"
            :label="`${s.icon} ${s.name}`"
            :value="s.id"
          />
        </el-select>
        <el-tooltip content="在当前学科下添加新的知识节点" placement="left">
          <el-button type="primary" size="small" @click="addNode">
            <el-icon><Plus /></el-icon>
            添加节点
          </el-button>
        </el-tooltip>
      </div>
    </div>

    <div class="kt-body" v-loading="treeStore.loading || saving">
      <el-tree
        v-if="treeStore.treeData.length > 0"
        :data="treeStore.treeData"
        :props="{ label: 'name', children: 'children' }"
        node-key="id"
        default-expand-all
        highlight-current
      >
        <template #default="{ data }">
          <span class="kt-node">
            <span class="kt-node__label">
              <el-tag size="small" :type="nodeTypeTag(data.nodeType)" class="kt-node__type">
                {{ nodeTypeLabel(data.nodeType) }}
              </el-tag>
              {{ data.name }}
            </span>
            <span class="kt-node__actions">
              <el-tooltip content="编辑节点信息" placement="top">
                <el-button text size="small" @click.stop="editNode(data)">
                  <el-icon><Edit /></el-icon>
                </el-button>
              </el-tooltip>
              <el-tooltip content="删除节点及其子节点" placement="top">
                <el-button text size="small" type="danger" @click.stop="deleteNode(data)">
                  <el-icon><Delete /></el-icon>
                </el-button>
              </el-tooltip>
            </span>
          </span>
        </template>
      </el-tree>
      <EmptyState v-else message="暂无知识树数据，请选择学科" icon="🌳" />
    </div>

    <el-dialog v-model="showDialog" :title="editingNode ? '编辑节点' : '添加节点'" width="500px">
      <el-form :model="nodeForm" label-position="top">
        <el-form-item label="名称" required>
          <el-input v-model="nodeForm.name" placeholder="节点名称" maxlength="100" show-word-limit />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="nodeForm.description" type="textarea" :rows="3" placeholder="节点描述" maxlength="500" show-word-limit />
        </el-form-item>
        <el-form-item label="类型" required>
          <el-select v-model="nodeForm.nodeType" style="width: 100%">
            <el-option label="章节 (Chapter)" value="CHAPTER">
              <span>📁 章节 (Chapter)</span>
            </el-option>
            <el-option label="节 (Section)" value="SECTION">
              <span>📂 节 (Section)</span>
            </el-option>
            <el-option label="知识点 (Topic)" value="TOPIC">
              <span>📄 知识点 (Topic)</span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="父节点">
          <el-tree-select
            v-model="nodeForm.parentId"
            :data="treeStore.treeData"
            :props="{ label: 'name', children: 'children', value: 'id' }"
            placeholder="可选，不选则为根节点"
            check-strictly
            clearable
            style="width: 100%"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showDialog = false" :disabled="saving">取消</el-button>
        <el-tooltip content="保存节点到数据库" placement="top">
          <el-button type="primary" @click="saveNode" :loading="saving">
            {{ editingNode ? '更新' : '创建' }}
          </el-button>
        </el-tooltip>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Plus, Edit, Delete } from '@element-plus/icons-vue'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import { useSubjectStore } from '@/stores/subject.store'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { KnowledgeNodeTreeItem, NodeType } from '@/types'

const treeStore = useKnowledgeTreeStore()
const subjectStore = useSubjectStore()

const showDialog = ref(false)
const editingNode = ref<KnowledgeNodeTreeItem | null>(null)
const saving = ref(false)
const subjectFilter = ref<number>(1)

const nodeForm = ref({
  name: '',
  description: '',
  nodeType: 'TOPIC' as NodeType,
  parentId: null as number | null,
})

onMounted(async () => {
  await subjectStore.fetchSubjects()
  if (subjectStore.subjects.length > 0) {
    subjectFilter.value = subjectStore.subjects[0].id
    await treeStore.fetchTree(subjectFilter.value)
  }
})

function onSubjectChange(id: number) {
  subjectFilter.value = id
  treeStore.fetchTree(id)
}

function nodeTypeTag(type: string): 'info' | 'warning' | '' {
  const map: Record<string, 'info' | 'warning' | ''> = {
    CHAPTER: '',
    SECTION: 'warning',
    TOPIC: 'info',
  }
  return map[type] || 'info'
}

function nodeTypeLabel(type: string): string {
  const map: Record<string, string> = {
    CHAPTER: '章',
    SECTION: '节',
    TOPIC: '点',
  }
  return map[type] || type
}

function addNode() {
  editingNode.value = null
  nodeForm.value = { name: '', description: '', nodeType: 'TOPIC', parentId: null }
  showDialog.value = true
}

function editNode(data: KnowledgeNodeTreeItem) {
  editingNode.value = data
  nodeForm.value = {
    name: data.name,
    description: '',
    nodeType: data.nodeType,
    parentId: null,
  }
  showDialog.value = true
}

async function deleteNode(data: KnowledgeNodeTreeItem) {
  try {
    await ElMessageBox.confirm(
      `确定要删除"${data.name}"${data.children?.length ? `及其 ${data.children.length} 个子节点` : ''}吗？此操作不可撤销。`,
      '确认删除',
      {
        type: 'warning',
        confirmButtonText: '删除',
        confirmButtonClass: 'el-button--danger',
      }
    )
    saving.value = true
    try {
      await treeStore.deleteNode(data.id)
      ElMessage.success(`"${data.name}" 已删除`)
    } catch {
      ElMessage.error('删除失败，请检查网络连接')
    } finally {
      saving.value = false
    }
  } catch {
    // cancelled
  }
}

async function saveNode() {
  if (!nodeForm.value.name.trim()) {
    ElMessage.warning('请输入节点名称')
    return
  }
  saving.value = true
  try {
    if (editingNode.value) {
      await treeStore.updateNode(editingNode.value.id, {
        name: nodeForm.value.name.trim(),
        description: nodeForm.value.description.trim(),
        nodeType: nodeForm.value.nodeType,
        parentId: nodeForm.value.parentId,
      })
      ElMessage.success('节点已更新')
    } else {
      await treeStore.createNode({
        subjectId: subjectFilter.value,
        name: nodeForm.value.name.trim(),
        description: nodeForm.value.description.trim(),
        nodeType: nodeForm.value.nodeType,
        parentId: nodeForm.value.parentId,
      })
      ElMessage.success('节点已创建')
    }
    showDialog.value = false
  } catch {
    ElMessage.error('操作失败，请检查网络连接')
  } finally {
    saving.value = false
  }
}
</script>

<style lang="scss" scoped>
.kt-manager {
  max-width: 900px;
}

.kt-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: var(--space-4);

  h2 { font-size: var(--font-size-xl); font-weight: 600; color: var(--color-text-primary); }

  &__actions {
    display: flex;
    align-items: center;
    gap: var(--space-2);
  }
}

.kt-body {
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  padding: var(--space-4);
  min-height: 200px;
}

.kt-node {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex: 1;
  padding-right: var(--space-2);

  &__label {
    display: flex;
    align-items: center;
    gap: var(--space-2);
  }

  &__type {
    font-size: 11px;
    flex-shrink: 0;
  }

  &__actions {
    display: flex;
    align-items: center;
    gap: 2px;
    opacity: 0;
    transition: opacity var(--transition-fast);
  }

  &:hover &__actions {
    opacity: 1;
  }
}
</style>
