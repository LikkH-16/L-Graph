import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { KnowledgeNode, KnowledgeNodeTreeItem } from '@/types'
import { knowledgeNodeApi } from '@/api/knowledge-node.api'

export const useKnowledgeTreeStore = defineStore('knowledge-tree', () => {
  const treeData = ref<KnowledgeNodeTreeItem[]>([])
  const flatNodeMap = ref<Map<number, KnowledgeNode>>(new Map())
  const selectedNodeId = ref<number | null>(null)
  const expandedKeys = ref<number[]>([])
  const loading = ref(false)

  const selectedNode = computed(() => {
    if (!selectedNodeId.value) return null
    return flatNodeMap.value.get(selectedNodeId.value) || null
  })

  async function fetchTree(subjectId: number) {
    loading.value = true
    try {
      const res = await knowledgeNodeApi.getTree(subjectId)
      treeData.value = res.tree
      // 后端返回的 nodes 是 Map<Long, KnowledgeNodeDto>，序列化为 Record<number, KnowledgeNode>
      // 直接转换为 Map，无需 walkTree 递归遍历
      flatNodeMap.value = new Map(
        Object.entries(res.nodes).map(([id, node]) => [Number(id), node])
      )
      // Auto-expand first level
      expandedKeys.value = res.tree.map(n => n.id)
    } catch (e) {
      console.error('[fetchTree] 获取知识树失败:', e)
    } finally {
      loading.value = false
    }
  }

  function selectNode(nodeId: number | null) {
    selectedNodeId.value = nodeId
  }

  function expandNode(nodeId: number) {
    if (!expandedKeys.value.includes(nodeId)) {
      expandedKeys.value.push(nodeId)
    }
  }

  function collapseNode(nodeId: number) {
    expandedKeys.value = expandedKeys.value.filter(k => k !== nodeId)
  }

  function setExpandedKeys(keys: number[]) {
    expandedKeys.value = keys
  }

  async function createNode(data: {
    subjectId: number
    name: string
    description?: string
    parentId?: number | null
    nodeType: 'CHAPTER' | 'SECTION' | 'TOPIC'
  }) {
    const node = await knowledgeNodeApi.create(data)
    await fetchTree(data.subjectId)
    return node
  }

  async function updateNode(id: number, data: {
    name?: string
    description?: string
    nodeType?: 'CHAPTER' | 'SECTION' | 'TOPIC'
    parentId?: number | null
    orderIndex?: number
  }) {
    const node = await knowledgeNodeApi.update(id, data)
    const subjectId = flatNodeMap.value.get(id)?.subjectId
    if (subjectId) await fetchTree(subjectId)
    return node
  }

  async function deleteNode(id: number) {
    const subjectId = flatNodeMap.value.get(id)?.subjectId
    await knowledgeNodeApi.delete(id)
    if (subjectId) await fetchTree(subjectId)
  }

  return {
    treeData, flatNodeMap, selectedNodeId, expandedKeys, loading, selectedNode,
    fetchTree, selectNode, expandNode, collapseNode, setExpandedKeys,
    createNode, updateNode, deleteNode,
  }
})

