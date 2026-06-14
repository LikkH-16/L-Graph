import type { Subject } from '@/types'
import { get } from './client'

export const subjectApi = {
  async getSubjects(): Promise<Subject[]> {
    return get<Subject[]>('/subjects')
  },

  async getSubject(id: number): Promise<Subject> {
    return get<Subject>(`/subjects/${id}`)
  },
}
