<template>
  <div class="note-editor-view">
    <div class="redirect-hint">
      <el-icon class="redirect-icon" :size="32"><Loading /></el-icon>
      <h2>正在导航到编辑界面...</h2>
      <p>多笔记支持正在开发中，正在为您跳转到学科详情页。</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Loading } from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()

onMounted(() => {
  // Redirect to subject detail — multi-note support is not yet implemented
  const subjectId = route.params.subjectId
  setTimeout(() => {
    router.replace(`/subjects/${subjectId}`)
  }, 300)
})
</script>

<style lang="scss" scoped>
.note-editor-view {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 400px;
}

.redirect-hint {
  text-align: center;

  .redirect-icon {
    color: var(--color-accent);
    margin-bottom: var(--space-4);
    animation: spin 1.5s linear infinite;
  }

  h2 {
    font-size: var(--font-size-xl);
    font-weight: 600;
    color: var(--color-text-primary);
    margin-bottom: var(--space-2);
  }

  p {
    font-size: var(--font-size-sm);
    color: var(--color-text-muted);
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
