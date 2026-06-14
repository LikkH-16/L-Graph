import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export type ViewMode = 'edit' | 'graph' | 'slides' | 'progress'
export type Theme = 'dark' | 'light'

export const useUiStore = defineStore('ui', () => {
  const sidebarCollapsed = ref(false)
  const rightPanelVisible = ref(true)
  const theme = ref<Theme>((localStorage.getItem('theme') as Theme) || 'dark')
  const viewMode = ref<ViewMode>('edit')
  const globalLoading = ref(false)
  const searchQuery = ref('')

  function toggleSidebar() {
    sidebarCollapsed.value = !sidebarCollapsed.value
  }

  function toggleRightPanel() {
    rightPanelVisible.value = !rightPanelVisible.value
  }

  function setTheme(t: Theme) {
    theme.value = t
    localStorage.setItem('theme', t)
    document.documentElement.setAttribute('data-theme', t)
  }

  function setViewMode(mode: ViewMode) {
    viewMode.value = mode
  }

  function setSearchQuery(query: string) {
    searchQuery.value = query
  }

  watch(theme, (t) => {
    document.documentElement.setAttribute('data-theme', t)
  }, { immediate: true })

  return { sidebarCollapsed, rightPanelVisible, theme, viewMode, globalLoading, searchQuery, toggleSidebar, toggleRightPanel, setTheme, setViewMode, setSearchQuery }
})
