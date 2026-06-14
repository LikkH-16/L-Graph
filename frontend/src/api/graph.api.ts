import type { GraphData } from '@/types'
import { get } from './client'

export const graphApi = {
  async getSubjectGraph(subjectId: number): Promise<GraphData> {
    return get<GraphData>(`/graph/subject/${subjectId}`)
  },

  async getPersonalizedGraph(subjectId: number): Promise<GraphData> {
    return get<GraphData>(`/graph/subject/${subjectId}/user`)
  },

  async getNodeNeighborhood(nodeId: string, depth = 2): Promise<GraphData> {
    return get<GraphData>(`/graph/node/${nodeId}/neighborhood`, { depth })
  },
}
