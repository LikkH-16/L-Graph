<template>
  <div class="subject-list-view">
    <div class="page-header">
      <div>
        <h1 class="page-title">我的学科</h1>
        <p class="page-desc">选择一门学科，开始构建你的知识图谱</p>
      </div>
    </div>

    <div v-if="subjectStore.loading" class="subject-grid">
      <div v-for="i in 4" :key="i" class="skeleton subject-skeleton" style="height: 200px;"></div>
    </div>

    <div v-else class="subject-grid">
      <div
        v-for="subject in subjectStore.subjects"
        :key="subject.id"
        class="subject-card card-glow"
        @click="enterSubject(subject.id)"
      >
        <div class="subject-card__icon">{{ subject.icon }}</div>
        <h3 class="subject-card__name">{{ subject.name }}</h3>
        <p class="subject-card__desc">{{ subject.description }}</p>
        <div class="subject-card__meta">
          <el-tooltip :content="`该学科共有 ${subject.knowledgeNodeCount} 个知识点待学习`" placement="top">
            <span class="subject-card__stat">
              <el-icon :size="14"><Collection /></el-icon>
              {{ subject.knowledgeNodeCount || 0 }} 知识点
            </span>
          </el-tooltip>
          <el-tooltip content="进入学科开始学习" placement="top">
            <span class="subject-card__arrow">
              <el-icon :size="16"><ArrowRight /></el-icon>
            </span>
          </el-tooltip>
        </div>
      </div>
    </div>

    <div v-if="!subjectStore.loading && subjectStore.subjects.length === 0" class="empty-wrap">
      <EmptyState message="暂无学科数据" icon="📚" />
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Collection, ArrowRight } from '@element-plus/icons-vue'
import { useSubjectStore } from '@/stores/subject.store'
import EmptyState from '@/components/common/EmptyState.vue'

const router = useRouter()
const subjectStore = useSubjectStore()

onMounted(() => {
  if (subjectStore.subjects.length === 0) {
    subjectStore.fetchSubjects()
  }
})

function enterSubject(id: number) {
  subjectStore.setCurrentSubject(id)
  router.push(`/subjects/${id}`)
}
</script>

<style lang="scss" scoped>
.subject-list-view {
  max-width: 1000px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: var(--space-8);
}

.page-title {
  font-size: var(--font-size-3xl);
  font-weight: 700;
  color: var(--color-text-primary);
  margin-bottom: var(--space-1);
}

.page-desc {
  color: var(--color-text-muted);
  font-size: var(--font-size-sm);
}

.subject-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: var(--space-5);
}

.subject-card {
  padding: var(--space-6);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: all var(--transition-normal);
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    inset: 0;
    background: radial-gradient(
      600px circle at var(--mouse-x, 50%) var(--mouse-y, 50%),
      rgba(124, 92, 231, 0.06),
      transparent 40%
    );
    opacity: 0;
    transition: opacity var(--transition-normal);
  }

  &:hover {
    border-color: var(--color-accent);
    transform: translateY(-3px);
    box-shadow: var(--shadow-glow);

    &::before {
      opacity: 1;
    }

    .subject-card__arrow {
      transform: translateX(3px);
      color: var(--color-accent-light);
    }
  }

  &__icon { font-size: 2.5rem; margin-bottom: var(--space-3); position: relative; }
  &__name { font-size: var(--font-size-lg); font-weight: 600; color: var(--color-text-primary); margin-bottom: var(--space-2); position: relative; }
  &__desc { font-size: var(--font-size-sm); color: var(--color-text-muted); line-height: var(--line-height-normal); margin-bottom: var(--space-4); display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; position: relative; }
  &__meta { display: flex; align-items: center; justify-content: space-between; position: relative; }
  &__stat { display: inline-flex; align-items: center; gap: 4px; font-size: var(--font-size-xs); color: var(--color-text-secondary); }
  &__arrow { color: var(--color-accent); transition: all var(--transition-bounce); display: flex; align-items: center; }
}

.subject-skeleton { border-radius: var(--radius-lg); }

.empty-wrap { padding: var(--space-12) 0; }
</style>
