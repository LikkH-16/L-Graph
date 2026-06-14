<template>
  <div class="error-view">
    <div class="error-code">403</div>
    <h1 class="error-title">访问被拒绝</h1>
    <p class="error-desc">你没有权限访问此页面</p>
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
  color: var(--color-danger);
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
