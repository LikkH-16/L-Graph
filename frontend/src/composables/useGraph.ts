import { ref, onUnmounted } from 'vue'
import { Graph, register, DagreLayout } from '@antv/g6'
import type { GraphNode, GraphEdge } from '@/types'

// Register dagre layout for G6 v5
register('layout', 'dagre', DagreLayout)

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
      theme: 'dark',
      node: {
        style: (d: Record<string, unknown>) => {
          const node = d as unknown as GraphNode & { _type?: string }
          const nodeType = (node as any)._type || node.type || 'knowledge'
          // Vibrant mastery color palette
          const masteryColors = ['#6366f1', '#f43f5e', '#f59e0b', '#10b981']
          const baseColor = node.color || masteryColors[node.masteryLevel || 0] || '#6366f1'
          return {
            fill: baseColor,
            stroke: nodeType === 'page' ? '#a78bfa' : 'rgba(255,255,255,0.15)',
            strokeWidth: nodeType === 'page' ? 2 : 0.5,
            size: node.size || 30,
            labelText: node.label,
            labelFill: '#f1f5f9',
            labelFontSize: 12,
            labelFontWeight: 500,
            labelPlacement: 'bottom',
            labelOffsetY: 8,
            shadowColor: node.masteryLevel === 3 ? 'rgba(16, 185, 129, 0.3)' : 'transparent',
            shadowBlur: 8,
            opacity: node.masteryLevel === 0 ? 0.65 : 0.95,
          }
        },
        state: {
          active: {
            stroke: '#a78bfa',
            strokeWidth: 3,
            shadowColor: 'rgba(167, 139, 250, 0.5)',
            shadowBlur: 16,
          },
        },
      },
      edge: {
        style: (d: Record<string, unknown>) => {
          const edge = d as unknown as GraphEdge
          const colorMap: Record<string, string> = {
            PARENT_OF: 'rgba(148, 163, 184, 0.45)',
            ATTACHED_TO: '#a78bfa',
            REFERENCES: 'rgba(56, 189, 248, 0.35)',
          }
          return {
            stroke: colorMap[edge.type] || 'rgba(148, 163, 184, 0.4)',
            lineWidth: edge.type === 'ATTACHED_TO' ? 2 : 1,
            lineDash: edge.type === 'REFERENCES' ? [6, 4] : undefined,
            endArrow: edge.type !== 'REFERENCES',
            opacity: edge.type === 'ATTACHED_TO' ? 0.7 : 0.4,
          }
        },
      },
      layout: {
        type: 'dagre',
        rankdir: 'LR',
        align: 'UL',
        nodesep: 30,
        ranksep: 50,
      },
      behaviors: [
        'drag-canvas',
        'zoom-canvas',
        { type: 'hover-activate', degree: 1, direction: 'both' },
      ],
      data: {
        nodes: data.nodes.map(n => {
          const { type, ...rest } = n as Record<string, unknown>
          return { ...rest, _type: type }
        }) as unknown as Record<string, unknown>[],
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
