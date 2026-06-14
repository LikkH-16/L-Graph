import type { Page, PageCreateRequest, PageUpdateRequest } from '@/types'
import { get, post, put, del, patch } from './client'

export const pageApi = {
  async getPages(noteId: number): Promise<Page[]> {
    return get<Page[]>('/pages', { noteId })
  },

  async getPage(id: number): Promise<Page> {
    return get<Page>(`/pages/${id}`)
  },

  async createPage(data: PageCreateRequest): Promise<Page> {
    return post<Page>('/pages', data)
  },

  async updatePage(id: number, data: PageUpdateRequest): Promise<Page> {
    return put<Page>(`/pages/${id}`, data)
  },

  async deletePage(id: number): Promise<void> {
    return del(`/pages/${id}`)
  },

  async attachToNode(pageId: number, nodeId: number): Promise<void> {
    return post(`/pages/${pageId}/attach/${nodeId}`)
  },

  async detachFromNode(pageId: number, nodeId: number): Promise<void> {
    return del(`/pages/${pageId}/detach/${nodeId}`)
  },

  async updateOrder(pageId: number, newIndex: number): Promise<void> {
    return patch(`/pages/${pageId}/order`, { orderIndex: newIndex })
  },
}
