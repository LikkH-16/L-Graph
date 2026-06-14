import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Note, Page } from '@/types'
import { noteApi } from '@/api/note.api'
import { pageApi } from '@/api/page.api'

export const useNoteStore = defineStore('note', () => {
  const currentNote = ref<Note | null>(null)
  const pages = ref<Page[]>([])
  const loading = ref(false)
  const saving = ref(false)

  const pageById = computed(() => {
    const map = new Map<number, Page>()
    pages.value.forEach(p => map.set(p.id, p))
    return map
  })

  async function fetchNote(subjectId: number) {
    loading.value = true
    try {
      // For now, get first note for the subject
      const notes = await noteApi.getNotesBySubject(subjectId)
      if (notes.length > 0) {
        currentNote.value = notes[0]
        pages.value = await noteApi.getNoteWithPages(notes[0].id)
      } else {
        currentNote.value = null
        pages.value = []
      }
    } finally {
      loading.value = false
    }
  }

  async function createNote(subjectId: number, title: string) {
    const note = await noteApi.createNote({ subjectId, title })
    currentNote.value = note
    return note
  }

  async function saveNote() {
    if (!currentNote.value) return
    saving.value = true
    try {
      await noteApi.updateNote(currentNote.value.id, { title: currentNote.value.title })
    } finally {
      saving.value = false
    }
  }

  async function createPage(title: string) {
    if (!currentNote.value) return
    const page = await pageApi.createPage({ noteId: currentNote.value.id, title })
    pages.value.push(page)
    pages.value.sort((a, b) => a.orderIndex - b.orderIndex)
    return page
  }

  async function deletePage(pageId: number) {
    await pageApi.deletePage(pageId)
    pages.value = pages.value.filter(p => p.id !== pageId)
  }

  async function reorderPage(pageId: number, newIndex: number) {
    const page = pages.value.find(p => p.id === pageId)
    if (!page) return
    const oldIndex = pages.value.indexOf(page)
    pages.value.splice(oldIndex, 1)
    pages.value.splice(newIndex, 0, page)
    pages.value.forEach((p, i) => { p.orderIndex = i })
    await pageApi.updateOrder(pageId, newIndex)
  }

  return { currentNote, pages, loading, saving, pageById, fetchNote, createNote, saveNote, createPage, deletePage, reorderPage }
})
