<template>
  <div class="markdown-editor">
    <div ref="editorContainer" class="markdown-editor__container"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, onUnmounted } from 'vue'
import { useMarkdown } from '@/composables/useMarkdown'
import { usePageStore } from '@/stores/page.store'

const props = defineProps<{
  modelValue: string
  /** 页面 ID，用于 Vditor localStorage 缓存标识 */
  pageId?: number
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const pageStore = usePageStore()
const { content, init, getValue, setValue, destroy } = useMarkdown()
const editorContainer = ref<HTMLElement | null>(null)

let saveTimer: ReturnType<typeof setInterval> | null = null

onMounted(() => {
  if (editorContainer.value) {
    init(editorContainer.value, props.modelValue, props.pageId ? `page-${props.pageId}` : undefined)
  }

  // Auto-save every 30 seconds
  saveTimer = setInterval(() => {
    if (pageStore.isDirty) {
      pageStore.content = getValue()
      pageStore.savePage()
    }
  }, 30000)
})

watch(() => props.modelValue, (val) => {
  if (content.value !== val) {
    setValue(val)
  }
})

watch(content, (val) => {
  emit('update:modelValue', val)
  pageStore.markDirty()
})

onUnmounted(() => {
  if (saveTimer) {
    clearInterval(saveTimer)
    saveTimer = null
  }
  // destroy() is already called by useMarkdown's onUnmounted
})
</script>

<style lang="scss" scoped>
.markdown-editor {
  height: 100%;
  min-height: 400px;

  &__container {
    height: 100%;
    border-radius: var(--radius-md);
    overflow: hidden;
  }
}
</style>
