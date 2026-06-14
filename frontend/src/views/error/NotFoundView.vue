<template>
  <div class="error-view">
    <div class="error-code">404</div>
    <h1 class="error-title">页面未找到</h1>
    <p class="error-desc">你访问的页面不存在或已被删除</p>
    <el-button type="primary" @click="$router.push('/subjects')">返回首页</el-button>
  </div>
</template>

<style lang="scss" scoped>
.error-view {
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: var(--color-bg-primary);
  gap: var(--space-3);
}

.error-code {
  font-size: 6rem;
  font-weight: 800;
  color: var(--color-accent);
  line-height: 1;
  opacity: 0.6;
}

.error-title {
  font-size: var(--font-size-2xl);
  font-weight: 600;
  color: var(--color-text-primary);
}

.error-desc {
  color: var(--color-text-muted);
  margin-bottom: var(--space-4);
}
</style>
