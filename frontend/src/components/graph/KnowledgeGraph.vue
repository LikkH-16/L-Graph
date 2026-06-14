<template>
  <div class="knowledge-graph-wrapper">
    <div ref="graphContainer" class="graph-container"></div>
    <GraphControls
      @fit="fitView"
      @zoom-in="zoomIn"
      @zoom-out="zoomOut"
    />
    <GraphLegend />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, onUnmounted } from 'vue'
import { useGraph } from '@/composables/useGraph'
import { useGraphStore } from '@/stores/graph.store'
import { useKnowledgeTreeStore } from '@/stores/knowledge-tree.store'
import GraphControls from './GraphControls.vue'
import GraphLegend from './GraphLegend.vue'

const graphStore = useGraphStore()
const treeStore = useKnowledgeTreeStore()
const { initGraph, fitView, zoomIn, zoomOut, destroyGraph } = useGraph()
const graphContainer = ref<HTMLElement | null>(null)

onMounted(async () => {
  if (graphContainer.value && graphStore.nodes.length > 0) {
    initGraph(graphContainer.value, {
      nodes: graphStore.nodes,
      edges: graphStore.edges,
    }, {
      onNodeClick(nodeId: string) {
        graphStore.selectNode(nodeId)
        const node = graphStore.nodes.find(n => n.id === nodeId)
        if (node?.knowledgeNodeId) {
          treeStore.selectNode(node.knowledgeNodeId)
        }
      },
    })
  }
})

watch(() => graphStore.nodes, () => {
  if (graphContainer.value && graphStore.nodes.length > 0) {
    initGraph(graphContainer.value, {
      nodes: graphStore.nodes,
      edges: graphStore.edges,
    }, {
      onNodeClick(nodeId: string) {
        graphStore.selectNode(nodeId)
      },
    })
  }
})

onUnmounted(() => {
  destroyGraph()
})

</script>

<style lang="scss" scoped>
.knowledge-graph-wrapper {
  width: 100%;
  height: 100%;
  position: relative;
  min-height: 500px;
}

.graph-container {
  width: 100%;
  height: 100%;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: radial-gradient(ellipse at center, #1a1a2e 0%, #0f0f1a 70%);
}
</style>
