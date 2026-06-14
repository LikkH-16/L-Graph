import { ref } from 'vue'

export function useTheme() {
  const isDark = ref(true)

  function toggle() {
    isDark.value = !isDark.value
    document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : 'light')
    localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
  }

  return { isDark, toggle }
}
