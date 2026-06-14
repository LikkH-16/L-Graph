import type { Router } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'

export function setupGuards(router: Router) {
  router.beforeEach((to, _from, next) => {
    const authStore = useAuthStore()

    if (to.meta.requiresAuth && !authStore.isAuthenticated) {
      return next({ name: 'Login', query: { redirect: to.fullPath } })
    }

    if (to.meta.guest && authStore.isAuthenticated) {
      return next({ name: 'Subjects' })
    }

    if (to.meta.requiresAdmin && !authStore.isAdmin) {
      return next({ name: 'Forbidden' })
    }

    next()
  })
}
