import type { KnowledgeNode, KnowledgeNodeTreeItem } from '@/types'
import { get, post, put, del } from './client'

export interface TreeResponse {
  tree: KnowledgeNodeTreeItem[]
  nodes: KnowledgeNode[]
}

export const knowledgeNodeApi = {
  async getTree(subjectId: number): Promise<TreeResponse> {
    return get<TreeResponse>(`/subjects/${subjectId}/knowledge-tree`)
  },

  async getNode(id: number): Promise<KnowledgeNode> {
    return get<KnowledgeNode>(`/knowledge-nodes/${id}`)
  },

  async getSiblings(id: number): Promise<KnowledgeNode[]> {
    return get<KnowledgeNode[]>(`/knowledge-nodes/${id}/siblings`)
  },

  async getPagesByNode(id: number): Promise<unknown[]> {
    return get<unknown[]>(`/knowledge-nodes/${id}/pages`)
  },

  async create(data: {
    subjectId: number
    name: string
    description?: string
    parentId?: number | null
    nodeType: 'CHAPTER' | 'SECTION' | 'TOPIC'
  }): Promise<KnowledgeNode> {
    return post<KnowledgeNode>('/knowledge-nodes', data)
  },

  async update(id: number, data: {
    name?: string
    description?: string
    nodeType?: 'CHAPTER' | 'SECTION' | 'TOPIC'
    parentId?: number | null
    orderIndex?: number
  }): Promise<KnowledgeNode> {
    return put<KnowledgeNode>(`/knowledge-nodes/${id}`, data)
  },

  async delete(id: number): Promise<void> {
    return del(`/knowledge-nodes/${id}`)
  },
}
