import type { AdminStats, User } from '@/types'
import { get, put, del } from './client'

export const adminApi = {
  async getStats(): Promise<AdminStats> {
    return get<AdminStats>('/admin/dashboard')
  },

  async getUsers(): Promise<User[]> {
    return get<User[]>('/admin/users')
  },

  async updateUserRole(userId: number, role: string): Promise<void> {
    return put(`/admin/users/${userId}/role`, { role })
  },

  async deleteUser(userId: number): Promise<void> {
    return del(`/admin/users/${userId}`)
  },
}
