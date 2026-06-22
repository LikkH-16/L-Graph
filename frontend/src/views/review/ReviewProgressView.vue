<template>
  <div class="review-progress-view">
    <div class="review-header">
      <div class="review-header-top">
        <el-tooltip content="返回学科详情" placement="bottom">
          <el-button text class="back-btn" @click="$router.push(`/subjects/${$route.params.subjectId}`)">
            <el-icon :size="18"><ArrowLeft /></el-icon>
            返回
          </el-button>
        </el-tooltip>
      </div>
      <h1 class="review-title">学习进度</h1>
      <p class="review-desc">追踪你的复习轨迹，掌握学习节奏</p>
    </div>

    <div v-if="reviewStore.loading">
      <LoadingSpinner text="正在加载进度数据..." />
    </div>

    <div v-else-if="reviewStore.subjectStats" class="review-content">
      <div class="stats-grid">
        <el-tooltip content="当前学科下的所有笔记页总数" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon><Document /></el-icon></div>
            <div class="stat-card__value">{{ reviewStore.subjectStats.totalPages }}</div>
            <div class="stat-card__label">总笔记页</div>
          </div>
        </el-tooltip>
        <el-tooltip content="至少完成过一次复习的笔记页数量" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon><Checked /></el-icon></div>
            <div class="stat-card__value">{{ reviewStore.subjectStats.pagesReviewed }}</div>
            <div class="stat-card__label">已复习页</div>
          </div>
        </el-tooltip>
        <el-tooltip content="已掌握页数占总页数的百分比" placement="top">
          <div class="stat-card accent">
            <div class="stat-card__icon"><el-icon><TrendCharts /></el-icon></div>
            <div class="stat-card__value">{{ reviewStore.subjectStats.completionPercent }}%</div>
            <div class="stat-card__label">完成度</div>
          </div>
        </el-tooltip>
        <el-tooltip content="掌握程度达到最高等级（已掌握）的笔记页数量" placement="top">
          <div class="stat-card">
            <div class="stat-card__icon"><el-icon><Trophy /></el-icon></div>
            <div class="stat-card__value">{{ reviewStore.subjectStats.masteredCount }}</div>
            <div class="stat-card__label">已掌握</div>
          </div>
        </el-tooltip>
      </div>

      <div class="round-breakdown">
        <h3 class="section-title">复习轮次分布</h3>
        <div class="round-bars">
          <div class="round-bar-item">
            <div class="round-bar-label">一轮</div>
            <div class="round-bar-track">
              <div
                class="round-bar-fill r1"
                :style="{ width: percent(reviewStore.subjectStats.round1Count, reviewStore.subjectStats.totalPages) }"
              ></div>
            </div>
            <el-tooltip :content="`${reviewStore.subjectStats.round1Count} 页在一轮复习中`" placement="top">
              <div class="round-bar-val">{{ reviewStore.subjectStats.round1Count }}</div>
            </el-tooltip>
          </div>
          <div class="round-bar-item">
            <div class="round-bar-label">二轮</div>
            <div class="round-bar-track">
              <div
                class="round-bar-fill r2"
                :style="{ width: percent(reviewStore.subjectStats.round2Count, reviewStore.subjectStats.totalPages) }"
              ></div>
            </div>
            <el-tooltip :content="`${reviewStore.subjectStats.round2Count} 页在二轮复习中`" placement="top">
              <div class="round-bar-val">{{ reviewStore.subjectStats.round2Count }}</div>
            </el-tooltip>
          </div>
          <div class="round-bar-item">
            <div class="round-bar-label">三轮</div>
            <div class="round-bar-track">
              <div
                class="round-bar-fill r3"
                :style="{ width: percent(reviewStore.subjectStats.round3Count, reviewStore.subjectStats.totalPages) }"
              ></div>
            </div>
            <el-tooltip :content="`${reviewStore.subjectStats.round3Count} 页在三轮复习中`" placement="top">
              <div class="round-bar-val">{{ reviewStore.subjectStats.round3Count }}</div>
            </el-tooltip>
          </div>
        </div>
      </div>

      <div class="page-list">
        <h3 class="section-title">笔记页列表</h3>
        <div v-if="noteStore.pages.length > 0" class="pages-table">
          <div
            v-for="page in noteStore.pages"
            :key="page.id"
            class="page-row"
          >
            <div class="page-row__info">
              <el-tooltip :content="masteryText(page.masteryLevel)" placement="top">
                <span
                  class="page-dot"
                  :style="{ background: masteryHexColor(page.masteryLevel) }"
                ></span>
              </el-tooltip>
              <span>{{ page.title }}</span>
            </div>
            <div class="page-row__actions">
              <el-tooltip :content="`已进行 ${page.reviewRound} 轮复习`" placement="top">
                <el-tag
                  :type="roundTagType(page.reviewRound)"
                  size="small"
                >
                  R{{ page.reviewRound }}
                </el-tag>
              </el-tooltip>
              <el-tooltip content="标记完成一次复习，掌握等级+1" placement="top">
                <el-button size="small" text @click="markReview(page)">
                  <el-icon><Select /></el-icon>
                  复习
                </el-button>
              </el-tooltip>
              <el-tooltip v-if="page.reviewRound > 0" content="撤销最近一次复习记录" placement="top">
                <el-button size="small" text type="warning" @click="undoReview(page)">
                  <el-icon><RefreshLeft /></el-icon>
                </el-button>
              </el-tooltip>
            </div>
          </div>
        </div>
        <EmptyState v-else message="暂无笔记页" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { Document, Checked, TrendCharts, Trophy, Select, RefreshLeft, ArrowLeft } from '@element-plus/icons-vue'
import { useReviewStore } from '@/stores/review.store'
import { useNoteStore } from '@/stores/note.store'
import { ElMessage } from 'element-plus'
import { masteryText, masteryHexColor, roundTagType } from '@/utils/mastery'
import type { Page } from '@/types'
import LoadingSpinner from '@/components/common/LoadingSpinner.vue'
import EmptyState from '@/components/common/EmptyState.vue'

const route = useRoute()
const reviewStore = useReviewStore()
const noteStore = useNoteStore()

onMounted(async () => {
  const subjectId = Number(route.params.subjectId)
  await Promise.all([
    reviewStore.fetchProgress(subjectId),
    noteStore.fetchNote(subjectId),
  ])
})

async function markReview(page: Page) {
  const newRound = Math.min(page.reviewRound + 1, 3)
  const newMastery = Math.min(page.masteryLevel + 1, 3)
  await reviewStore.recordReview(page.id, newRound, newMastery)
  page.reviewRound = newRound
  page.masteryLevel = newMastery as 0 | 1 | 2 | 3
  ElMessage.success('已记录复习')
}

async function undoReview(page: Page) {
  const newRound = Math.max(page.reviewRound - 1, 0)
  const newMastery = Math.max(page.masteryLevel - 1, 0)
  await reviewStore.recordReview(page.id, newRound, newMastery)
  page.reviewRound = newRound
  page.masteryLevel = newMastery as 0 | 1 | 2 | 3
  ElMessage.success('已撤销复习')
}

function percent(count: number, total: number): string {
  if (total === 0) return '0%'
  return Math.round((count / total) * 100) + '%'
}
</script>

<style lang="scss" scoped>
.review-progress-view {
  max-width: 900px;
  margin: 0 auto;
}

.review-header {
  margin-bottom: var(--space-6);
}

.review-header-top {
  margin-bottom: var(--space-2);
}

.back-btn {
  color: var(--color-text-muted) !important;
  padding: 4px 10px;
  &:hover { color: var(--color-accent-light) !important; background: var(--color-bg-card-hover) !important; }
}

.review-title {
  font-size: var(--font-size-2xl);
  font-weight: 700;
  color: var(--color-text-primary);
  margin-bottom: 2px;
}

.review-desc {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: var(--space-3);
  margin-bottom: var(--space-6);
}

.stat-card {
  padding: var(--space-4);
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

  &.accent {
    border-color: var(--color-accent);
    background: rgba(124, 92, 231, 0.08);

    &:hover {
      box-shadow: var(--shadow-glow);
    }
  }

  &__icon {
    color: var(--color-accent-light);
    margin-bottom: var(--space-1);
    font-size: var(--font-size-lg);
  }

  &__value {
    font-size: var(--font-size-2xl);
    font-weight: 700;
    color: var(--color-text-primary);
    margin-bottom: 2px;
  }

  &__label {
    font-size: var(--font-size-xs);
    color: var(--color-text-muted);
  }
}

.section-title {
  font-size: var(--font-size-base);
  font-weight: 600;
  color: var(--color-text-primary);
  margin-bottom: var(--space-3);
}

.round-breakdown {
  margin-bottom: var(--space-6);
}

.round-bars {
  display: flex;
  flex-direction: column;
  gap: var(--space-2);
}

.round-bar-item {
  display: flex;
  align-items: center;
  gap: var(--space-3);
}

.round-bar-label {
  width: 40px;
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
}

.round-bar-track {
  flex: 1;
  height: 8px;
  background: var(--color-bg-primary);
  border-radius: var(--radius-full);
  overflow: hidden;
}

.round-bar-fill {
  height: 100%;
  border-radius: var(--radius-full);
  transition: width var(--transition-slow);

  &.r1 { background: #e74c3c; }
  &.r2 { background: #f39c12; }
  &.r3 { background: #2ecc71; }
}

.round-bar-val {
  width: 30px;
  font-size: var(--font-size-sm);
  color: var(--color-text-secondary);
  text-align: right;
  cursor: default;
}

.pages-table {
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
  overflow: hidden;
}

.page-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-3) var(--space-4);
  border-bottom: 1px solid var(--color-border);

  &:last-child { border-bottom: none; }

  &:hover { background: var(--color-bg-card-hover); }

  &__info {
    display: flex;
    align-items: center;
    gap: var(--space-2);
    font-size: var(--font-size-sm);
    color: var(--color-text-primary);
  }

  &__actions {
    display: flex;
    align-items: center;
    gap: var(--space-2);
  }
}

.page-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
</style>
