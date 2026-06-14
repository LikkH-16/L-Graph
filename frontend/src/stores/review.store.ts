import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { ReviewProgress, SubjectStats } from '@/types'
import { reviewApi } from '@/api/review.api'

export const useReviewStore = defineStore('review', () => {
  const progressMap = ref<Map<number, ReviewProgress>>(new Map())
  const subjectStats = ref<SubjectStats | null>(null)
  const loading = ref(false)

  const overallCompletion = computed(() =>
    subjectStats.value?.completionPercent || 0
  )

  function pageProgress(pageId: number): ReviewProgress | null {
    return progressMap.value.get(pageId) || null
  }

  async function fetchProgress(subjectId: number) {
    loading.value = true
    try {
      const stats = await reviewApi.getSubjectProgress(subjectId)
      subjectStats.value = stats
    } finally {
      loading.value = false
    }
  }

  async function recordReview(pageId: number, round: number, masteryLevel: number) {
    await reviewApi.recordReview({
      pageId,
      reviewRound: round,
      masteryLevel,
      timeSpentSeconds: 0,
    })
    progressMap.value.set(pageId, {
      pageId,
      reviewRound: round,
      masteryLevel,
      reviewCount: (progressMap.value.get(pageId)?.reviewCount || 0) + 1,
      lastReviewedAt: new Date().toISOString(),
    })
  }

  return { progressMap, subjectStats, loading, overallCompletion, pageProgress, fetchProgress, recordReview }
})
