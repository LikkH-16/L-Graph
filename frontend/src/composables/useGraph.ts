import { ref, onUnmounted } from 'vue'
import { Graph } from '@antv/g6'
import type { GraphNode, GraphEdge } from '@/types'

export function useGraph() {
  const graphInstance = ref<Graph | null>(null)
  const isReady = ref(false)

  function initGraph(
    container: HTMLElement,
    data: { nodes: GraphNode[]; edges: GraphEdge[] },
    options: {
      onNodeClick?: (nodeId: string) => void
      onNodeHover?: (nodeId: string | null) => void
    } = {}
  ) {
    if (graphInstance.value) {
      graphInstance.value.destroy()
    }

    const width = container.clientWidth
    const height = container.clientHeight

    graphInstance.value = new Graph({
      container,
      width,
      height,
      autoFit: 'view',
      animation: false,
      background: 'transparent',
      node: {
        style: (d: Record<string, unknown>) => {
          const node = d as unknown as GraphNode
          return {
            fill: node.color || '#3a3a5c',
            stroke: node.type === 'page' ? '#7c5ce7' : 'transparent',
            strokeWidth: node.type === 'page' ? 1.5 : 0,
            size: node.size || 30,
            labelText: node.label,
            labelFill: '#e8e8f0',
            labelFontSize: 10,
            labelPlacement: 'bottom',
            labelOffsetY: 6,
            opacity: node.masteryLevel === 0 ? 0.5 : 1,
          }
        },
        state: {
          active: {
            stroke: '#7c5ce7',
            strokeWidth: 3,
            shadowColor: 'rgba(124, 92, 231, 0.5)',
            shadowBlur: 12,
          },
        },
      },
      edge: {
        style: (d: Record<string, unknown>) => {
          const edge = d as unknown as GraphEdge
          const colorMap: Record<string, string> = {
            PARENT_OF: '#3a3a5c',
            ATTACHED_TO: '#7c5ce7',
            REFERENCES: '#3498db',
          }
          return {
            stroke: colorMap[edge.type] || '#3a3a5c',
            lineWidth: edge.type === 'ATTACHED_TO' ? 2 : 1,
            lineDash: edge.type === 'REFERENCES' ? [4, 4] : undefined,
            endArrow: edge.type !== 'REFERENCES',
            opacity: 0.4,
          }
        },
      },
      layout: {
        // 【修改】从 'force' 改为 'dagre' 布局，计算快且不会抖动卡死
        type: 'dagre',
        rankdir: 'LR', // 从左到右
        align: 'UL',
        nodesepFunc: () => 30,
        ranksepFunc: () => 50
      },
      behaviors: [
        'drag-canvas',
        'zoom-canvas',
        { type: 'hover-activate', degree: 1, direction: 'both' },
      ],
      data: {
        nodes: data.nodes as unknown as Record<string, unknown>[],
        edges: data.edges.map(e => ({ source: e.source, target: e.target, data: e })) as unknown as Record<string, unknown>[],
      },
    })

    graphInstance.value.on('node:click', (evt: Record<string, unknown>) => {
      const nodeId = (evt.target as Record<string, unknown>)?.id as string
      if (nodeId && options.onNodeClick) {
        options.onNodeClick(nodeId)
      }
    })

    graphInstance.value.render().then(() => {
      isReady.value = true
    })
  }

  function updateData(nodes: GraphNode[], edges: GraphEdge[]) {
    if (!graphInstance.value) return
    graphInstance.value.setData({
      nodes: nodes as unknown as Record<string, unknown>[],
      edges: edges.map(e => ({ source: e.source, target: e.target, data: e })) as unknown as Record<string, unknown>[],
    })
    graphInstance.value.render()
  }

  function focusOnNode(nodeId: string) {
    graphInstance.value?.focusElement(nodeId)
  }

  function fitView() {
    graphInstance.value?.fitView()
  }

  function zoomIn() {
    graphInstance.value?.zoomTo(graphInstance.value.getZoom() * 1.2)
  }

  function zoomOut() {
    graphInstance.value?.zoomTo(graphInstance.value.getZoom() * 0.8)
  }

  function destroyGraph() {
    if (graphInstance.value) {
      graphInstance.value.destroy()
      graphInstance.value = null
    }
    isReady.value = false
  }

  onUnmounted(() => {
    destroyGraph()
  })

  return { graphInstance, isReady, initGraph, updateData, focusOnNode, fitView, zoomIn, zoomOut, destroyGraph }
}
