import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Page } from '@/types'
import { pageApi } from '@/api/page.api'

export const usePageStore = defineStore('page', () => {
  const currentPage = ref<Page | null>(null)
  const content = ref('')
  const attachedNodeIds = ref<number[]>([])
  const saving = ref(false)
  const isDirty = ref(false)

  const attachedNodes = computed(() => attachedNodeIds.value)

  async function fetchPage(pageId: number) {
    try {
      const page = await pageApi.getPage(pageId)
      currentPage.value = page
      content.value = page.content
      attachedNodeIds.value = page.attachedNodeIds
      isDirty.value = false
    } catch {
      // handle error
    }
  }

  async function savePage() {
    if (!currentPage.value || !isDirty.value) return
    saving.value = true
    try {
      await pageApi.updatePage(currentPage.value.id, {
        content: content.value,
      })
      isDirty.value = false
    } finally {
      saving.value = false
    }
  }

  async function attachToNode(nodeId: number) {
    if (!currentPage.value) return
    await pageApi.attachToNode(currentPage.value.id, nodeId)
    if (!attachedNodeIds.value.includes(nodeId)) {
      attachedNodeIds.value.push(nodeId)
    }
  }

  async function detachFromNode(nodeId: number) {
    if (!currentPage.value) return
    await pageApi.detachFromNode(currentPage.value.id, nodeId)
    attachedNodeIds.value = attachedNodeIds.value.filter(id => id !== nodeId)
  }

  function markDirty() {
    isDirty.value = true
  }

  async function updatePage(id: number, data: { title?: string; content?: string; orderIndex?: number }) {
    if (!currentPage.value) return
    await pageApi.updatePage(id, data)
    if (data.content !== undefined) {
      isDirty.value = false
    }
  }

  async function deletePage(id: number) {
    await pageApi.deletePage(id)
    if (currentPage.value?.id === id) {
      currentPage.value = null
      content.value = ''
      attachedNodeIds.value = []
      isDirty.value = false
    }
  }

  function clearDirty() {
    isDirty.value = false
  }

  return {
    currentPage, content, attachedNodeIds, saving, isDirty, attachedNodes,
    fetchPage, savePage, updatePage, deletePage, attachToNode, detachFromNode,
    markDirty, clearDirty,
  }
})
