import { ref, type Ref } from 'vue'

export function useDebounce<T>(fn: (value: T) => void, delay = 300) {
  let timer: ReturnType<typeof setTimeout> | null = null

  return (value: T) => {
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => fn(value), delay)
  }
}

export function useDebouncedRef<T>(initialValue: T, delay = 300): Ref<T> {
  const state = ref(initialValue) as Ref<T>
  let timer: ReturnType<typeof setTimeout> | null = null

  return new Proxy(state, {
    set(target, prop, value) {
      if (prop === 'value') {
        if (timer) clearTimeout(timer)
        timer = setTimeout(() => {
          target.value = value
        }, delay)
        return true
      }
      return Reflect.set(target, prop, value)
    },
  })
}
