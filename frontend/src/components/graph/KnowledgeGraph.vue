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
const initialized = ref(false)
let retryTimer: ReturnType<typeof setTimeout> | null = null

onMounted(() => {
  if (graphStore.nodes.length > 0) {
    tryInit()
  }
})

watch(() => graphStore.nodes.length, (len) => {
  if (len > 0 && !initialized.value) {
    tryInit()
  }
})

function tryInit() {
  if (initialized.value) return
  const el = graphContainer.value
  if (!el || el.clientWidth === 0 || el.clientHeight === 0) {
    if (retryTimer) clearTimeout(retryTimer)
    retryTimer = setTimeout(tryInit, 200)
    return
  }
  try {
    initGraph(el, {
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
    initialized.value = true
  } catch (e) {
    console.error('[KnowledgeGraph] Failed to initialize graph:', e)
  }
}

onUnmounted(() => {
  if (retryTimer) clearTimeout(retryTimer)
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
  min-height: 500px;
  border-radius: var(--radius-lg);
  border: 1px solid var(--color-border);
  background: radial-gradient(ellipse at center, #1e1b4b 0%, #0f0d2e 60%, #020617 100%);
}
</style>
