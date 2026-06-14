// ===== Mastery Level Shared Utilities =====
// Centralized helper functions for mastery level display across all views.
// Previously duplicated in SubjectDetailView, GraphExplorerView, ReviewProgressView.

/** Map mastery level (0-3) to display color */
export function masteryColor(level: number): string {
  const colors: Record<number, string> = {
    0: 'var(--color-mastery-0)',
    1: 'var(--color-mastery-1)',
    2: 'var(--color-mastery-2)',
    3: 'var(--color-mastery-3)',
  }
  return colors[level] || colors[0]
}

/** Get raw hex color for mastery level (non-CSS-variable, e.g. for canvas) */
export function masteryHexColor(level: number): string {
  const colors: Record<number, string> = {
    0: '#3a3a3c', // 柔灰
    1: '#b56c6c', // 莫兰迪红
    2: '#bfa46f', // 莫兰迪黄
    3: '#638c70', // 莫兰迪绿
  }
  return colors[level] || colors[0]
}

/** Map mastery level to Element Plus tag type */
export function masteryTagType(level: number): 'danger' | 'warning' | 'success' | 'info' {
  const map: Record<number, 'danger' | 'warning' | 'success' | 'info'> = {
    0: 'info',
    1: 'danger',
    2: 'warning',
    3: 'success',
  }
  return map[level] || 'info'
}

/** Map review round (0-3) to tag type */
export function roundTagType(round: number): 'info' | 'danger' | 'warning' | 'success' | '' {
  const map: Record<number, 'info' | 'danger' | 'warning' | 'success' | ''> = {
    0: 'info',
    1: 'danger',
    2: 'warning',
    3: 'success',
  }
  return map[round] || 'info'
}

/** Map mastery level to Chinese display text */
export function masteryText(level: number): string {
  const map: Record<number, string> = {
    0: '未学习',
    1: '一轮复习',
    2: '二轮复习',
    3: '已掌握',
  }
  return map[level] || '未学习'
}

/** Map review round to Chinese display text */
export function roundText(round: number): string {
  const map: Record<number, string> = {
    0: '未复习',
    1: '一轮复习',
    2: '二轮复习',
    3: '三轮复习',
  }
  return map[round] || '未复习'
}

/** Get complete mastery label object for a given level */
export function masteryLabel(level: number): {
  color: string
  hexColor: string
  tagType: 'danger' | 'warning' | 'success' | 'info'
  text: string
} {
  return {
    color: masteryColor(level),
    hexColor: masteryHexColor(level),
    tagType: masteryTagType(level),
    text: masteryText(level),
  }
}
