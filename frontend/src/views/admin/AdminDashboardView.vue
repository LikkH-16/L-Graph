<template>
  <div class="admin-dashboard">
    <div class="admin-header">
      <h1 class="admin-title">管理后台</h1>
      <p class="admin-desc">系统数据统计与快捷管理</p>
    </div>

    <!-- Error state -->
    <div v-if="error" class="error-state">
      <EmptyState message="加载数据失败" icon="⚠️">
        <el-button type="primary" @click="loadStats" :loading="loading">
          <el-icon><Refresh /></el-icon>
          重试
        </el-button>
      </EmptyState>
    </div>

    <!-- Loading state -->
    <div v-else-if="loading" class="stats-grid">
      <div v-for="i in 6" :key="i" class="skeleton" style="height: 120px; border-radius: var(--radius-md);"></div>
    </div>

    <!-- Data state -->
    <template v-else-if="stats">
      <div class="stats-grid">
        <el-tooltip content="系统中注册的用户总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><User /></el-icon></div>
            <div class="stat-card__value">{{ stats.userCount }}</div>
            <div class="stat-card__label">用户数</div>
          </div>
        </el-tooltip>
        <el-tooltip content="系统中的学科门类总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><Collection /></el-icon></div>
            <div class="stat-card__value">{{ stats.subjectCount }}</div>
            <div class="stat-card__label">学科</div>
          </div>
        </el-tooltip>
        <el-tooltip content="知识树中的知识点节点总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><Share /></el-icon></div>
            <div class="stat-card__value">{{ stats.knowledgeNodeCount }}</div>
            <div class="stat-card__label">知识点</div>
          </div>
        </el-tooltip>
        <el-tooltip content="所有用户创建的笔记总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><Document /></el-icon></div>
            <div class="stat-card__value">{{ stats.noteCount }}</div>
            <div class="stat-card__label">笔记</div>
          </div>
        </el-tooltip>
        <el-tooltip content="所有笔记中的页面总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><Tickets /></el-icon></div>
            <div class="stat-card__value">{{ stats.pageCount }}</div>
            <div class="stat-card__label">页面</div>
          </div>
        </el-tooltip>
        <el-tooltip content="所有用户的复习记录总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon :size="22"><TrendCharts /></el-icon></div>
            <div class="stat-card__value">{{ stats.reviewCount }}</div>
            <div class="stat-card__label">复习记录</div>
          </div>
        </el-tooltip>
      </div>

      <div class="quick-links">
        <h3 class="section-title">快捷操作</h3>
        <div class="quick-links-grid">
          <el-tooltip content="管理学科标准知识树的结构和节点" placement="top">
            <div class="quick-link-card card-glow" @click="$router.push('/admin/knowledge-tree')">
              <el-icon :size="24"><Share /></el-icon>
              <span>管理知识树</span>
              <small>维护学科知识节点体系</small>
            </div>
          </el-tooltip>
          <el-tooltip content="查看和管理系统用户及权限" placement="top">
            <div class="quick-link-card card-glow" @click="$router.push('/admin/users')">
              <el-icon :size="24"><User /></el-icon>
              <span>管理用户</span>
              <small>用户列表与角色分配</small>
            </div>
          </el-tooltip>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { User, Collection, Share, Document, Tickets, TrendCharts, Refresh } from '@element-plus/icons-vue'
import { adminApi } from '@/api/admin.api'
import type { AdminStats } from '@/types'
import EmptyState from '@/components/common/EmptyState.vue'

const stats = ref<AdminStats | null>(null)
const loading = ref(true)
const error = ref(false)

onMounted(() => {
  loadStats()
})

async function loadStats() {
  loading.value = true
  error.value = false
  try {
    stats.value = await adminApi.getStats()
  } catch {
    error.value = true
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.admin-dashboard {
  max-width: 1000px;
}

.admin-header {
  margin-bottom: var(--space-6);
}

.admin-title {
  font-size: var(--font-size-2xl);
  font-weight: 700;
  color: var(--color-text-primary);
  margin-bottom: 2px;
}

.admin-desc {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

.section-title {
  font-size: var(--font-size-base);
  font-weight: 600;
  color: var(--color-text-primary);
  margin-bottom: var(--space-3);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: var(--space-4);
  margin-bottom: var(--space-8);
}

.stat-card {
  padding: var(--space-5);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  text-align: center;
  cursor: default;
  transition: all var(--transition-fast);

  &:hover {
    border-color: var(--color-border-light);
    transform: translateY(-1px);
  }

  &__icon { color: var(--color-accent-light); margin-bottom: var(--space-2); }
  &__value { font-size: var(--font-size-3xl); font-weight: 700; color: var(--color-text-primary); }
  &__label { font-size: var(--font-size-xs); color: var(--color-text-muted); margin-top: 4px; }
}

.error-state {
  padding: var(--space-12) 0;
}

.quick-links {
  margin-bottom: var(--space-6);
}

.quick-links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: var(--space-4);
}

.quick-link-card {
  padding: var(--space-5);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: var(--space-2);

  .el-icon {
    color: var(--color-accent-light);
  }

  span {
    font-size: var(--font-size-sm);
    font-weight: 600;
    color: var(--color-text-primary);
  }

  small {
    font-size: var(--font-size-xs);
    color: var(--color-text-muted);
  }
}
</style>
