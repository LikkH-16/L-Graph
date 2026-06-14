import type { LoginCredentials, RegisterData, LoginResponse, User } from '@/types'
import { post, get } from './client'

export const authApi = {
  async login(data: LoginCredentials): Promise<LoginResponse> {
    return post<LoginResponse>('/auth/login', data)
  },

  async register(data: RegisterData): Promise<LoginResponse> {
    return post<LoginResponse>('/auth/register', data)
  },

  async getMe(): Promise<User> {
    return get<User>('/auth/me')
  },
}
