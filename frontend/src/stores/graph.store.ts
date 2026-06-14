import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { GraphNode, GraphEdge } from '@/types'
import { graphApi } from '@/api/graph.api'

export type GraphLayout = 'force' | 'dagre' | 'circular' | 'radial'

export const useGraphStore = defineStore('graph', () => {
  const nodes = ref<GraphNode[]>([])
  const edges = ref<GraphEdge[]>([])
  const layout = ref<GraphLayout>('force')
  const selectedNodeId = ref<string | null>(null)
  const loading = ref(false)

  const selectedNode = computed(() =>
    nodes.value.find(n => n.id === selectedNodeId.value) || null
  )

  const neighborsOf = computed(() => {
    const neighborIds = new Set<string>()
    if (!selectedNodeId.value) return neighborIds
    edges.value.forEach(e => {
      if (e.source === selectedNodeId.value) neighborIds.add(e.target)
      if (e.target === selectedNodeId.value) neighborIds.add(e.source)
    })
    return neighborIds
  })

  async function fetchGraphData(subjectId: number) {
    loading.value = true
    try {
      const data = await graphApi.getSubjectGraph(subjectId)
      nodes.value = data.nodes
      edges.value = data.edges
    } finally {
      loading.value = false
    }
  }

  function selectNode(nodeId: string | null) {
    selectedNodeId.value = nodeId
  }

  function setLayout(name: GraphLayout) {
    layout.value = name
  }

  function updateNodeStyle(nodeId: string, color: string, size: number) {
    const node = nodes.value.find(n => n.id === nodeId)
    if (node) {
      node.color = color
      node.size = size
    }
  }

  return { nodes, edges, layout, selectedNodeId, loading, selectedNode, neighborsOf, fetchGraphData, selectNode, setLayout, updateNodeStyle }
})
