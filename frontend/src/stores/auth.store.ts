import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User, LoginCredentials, RegisterData } from '@/types'
import { authApi } from '@/api/auth.api'

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const token = ref<string | null>(null)
  const loading = ref(false)

  const isAuthenticated = computed(() => !!token.value)
  const isAdmin = computed(() => user.value?.role === 'ADMIN')
  const currentUserId = computed(() => user.value?.id)

  function setAuth(tokenValue: string, userData: User) {
    token.value = tokenValue
    user.value = userData
    localStorage.setItem('token', tokenValue)
  }

  async function login(credentials: LoginCredentials) {
    loading.value = true
    try {
      const res = await authApi.login(credentials)
      setAuth(res.token, res.user)
      return true
    } finally {
      loading.value = false
    }
  }

  async function register(data: RegisterData) {
    loading.value = true
    try {
      const res = await authApi.register(data)
      setAuth(res.token, res.user)
      return true
    } finally {
      loading.value = false
    }
  }

  function logout() {
    token.value = null
    user.value = null
    localStorage.removeItem('token')
  }

  async function fetchCurrentUser() {
    if (!token.value) return
    try {
      const res = await authApi.getMe()
      user.value = res
    } catch {
      logout()
    }
  }

  return { user, token, loading, isAuthenticated, isAdmin, currentUserId, login, register, logout, fetchCurrentUser }
})
