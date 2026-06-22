import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { Subject } from '@/types'
import { subjectApi } from '@/api/subject.api'

export const useSubjectStore = defineStore('subject', () => {
  const subjects = ref<Subject[]>([])
  const currentSubjectId = ref<number | null>(null)
  const loading = ref(false)

  const currentSubject = computed(() =>
    subjects.value.find(s => s.id === currentSubjectId.value) || null
  )

  async function fetchSubjects() {
    loading.value = true
    try {
      const res = await subjectApi.getSubjects()
      subjects.value = res
    } finally {
      loading.value = false
    }
  }

  function setCurrentSubject(id: number) {
    currentSubjectId.value = id
  }

  function clearCurrentSubject() {
    currentSubjectId.value = null
  }

  return { subjects, currentSubjectId, currentSubject, loading, fetchSubjects, setCurrentSubject, clearCurrentSubject }
})
