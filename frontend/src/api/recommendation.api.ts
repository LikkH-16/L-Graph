import type { Recommendation } from '@/types'
import { get } from './client'

export const recommendationApi = {
  async getSiblings(pageId: number): Promise<Recommendation[]> {
    return get<Recommendation[]>(`/recommendations/page/${pageId}/siblings`)
  },

  async getMistakes(pageId: number): Promise<Recommendation[]> {
    return get<Recommendation[]>(`/recommendations/page/${pageId}/mistakes`)
  },

  async getNext(nodeId: number): Promise<Recommendation[]> {
    return get<Recommendation[]>(`/recommendations/node/${nodeId}/next`)
  },
}
