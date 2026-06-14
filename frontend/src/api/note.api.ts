import type { Note, Page } from '@/types'
import { get, post, put, del } from './client'

export const noteApi = {
  async getNotesBySubject(subjectId: number): Promise<Note[]> {
    return get<Note[]>('/notes', { subjectId })
  },

  async getNoteWithPages(noteId: number): Promise<Page[]> {
    return get<Page[]>(`/notes/${noteId}`)
  },

  async createNote(data: { subjectId: number; title: string }): Promise<Note> {
    return post<Note>('/notes', data)
  },

  async updateNote(id: number, data: Partial<Note>): Promise<Note> {
    return put<Note>(`/notes/${id}`, data)
  },

  async deleteNote(id: number): Promise<void> {
    return del(`/notes/${id}`)
  },
}
