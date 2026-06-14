<template>
  <div class="slide-show-view">
    <SlideRenderer
      v-if="slideHtml"
      :html="slideHtml"
      @exit="goBack"
    />

    <!-- Slide counter overlay -->
    <div v-if="slideHtml" class="slide-counter">
      演示模式 · 按 ← → 翻页 · 按 F 全屏 · 按 Esc 退出
    </div>

    <!-- Loading state -->
    <div v-else-if="!error" class="slide-loading">
      <LoadingSpinner text="正在准备演示..." />
      <p class="slide-loading__hint">正在将笔记页渲染为幻灯片...</p>
    </div>

    <!-- Error state -->
    <div v-else class="slide-error">
      <EmptyState message="演示生成失败" icon="⚠️">
        <p class="error-detail">{{ error }}</p>
        <el-tooltip content="返回笔记编辑页面" placement="top">
          <el-button @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            返回编辑
          </el-button>
        </el-tooltip>
      </EmptyState>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft } from '@element-plus/icons-vue'
import { useNoteStore } from '@/stores/note.store'
import { useSlide } from '@/composables/useSlide'
import SlideRenderer from '@/components/slide/SlideRenderer.vue'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import EmptyState from '@/components/common/EmptyState.vue'

const route = useRoute()
const router = useRouter()
const noteStore = useNoteStore()
const { buildSlides } = useSlide()
const slideHtml = ref('')
const error = ref('')

onMounted(async () => {
  try {
    const subjectId = Number(route.params.subjectId)
    await noteStore.fetchNote(subjectId)
    slideHtml.value = buildSlides(noteStore.pages)
  } catch (e) {
    error.value = e instanceof Error ? e.message : '生成演示时发生未知错误'
  }
})

function goBack() {
  const subjectId = route.params.subjectId
  router.push(`/subjects/${subjectId}`)
}
</script>

<style lang="scss" scoped>
.slide-show-view {
  position: relative;
}

.slide-counter {
  position: fixed;
  bottom: var(--space-4);
  left: 50%;
  transform: translateX(-50%);
  z-index: var(--z-overlay);
  padding: var(--space-2) var(--space-4);
  background: var(--color-bg-glass);
  backdrop-filter: blur(12px);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-full);
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  pointer-events: none;
  white-space: nowrap;
}

.slide-loading {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-primary);

  &__hint {
    margin-top: var(--space-4);
    font-size: var(--font-size-sm);
    color: var(--color-text-muted);
  }
}

.slide-error {
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-primary);
}

.error-detail {
  font-size: var(--font-size-xs);
  color: var(--color-danger);
  margin-bottom: var(--space-4);
  max-width: 400px;
  word-break: break-all;
}
</style>
