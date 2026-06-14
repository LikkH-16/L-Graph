import type { ReviewRecord, SubjectStats } from '@/types'
import { get, post } from './client'

export const reviewApi = {
  async recordReview(data: {
    pageId: number
    reviewRound: number
    masteryLevel: number
    timeSpentSeconds: number
    notes?: string
  }): Promise<ReviewRecord> {
    return post<ReviewRecord>('/reviews', data)
  },

  async getSubjectProgress(subjectId: number): Promise<SubjectStats> {
    return get<SubjectStats>(`/reviews/subject/${subjectId}`)
  },

  async getPageHistory(pageId: number): Promise<ReviewRecord[]> {
    return get<ReviewRecord[]>(`/reviews/page/${pageId}/history`)
  },
}
