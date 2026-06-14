<template>
  <div class="user-manager">
    <div class="um-header">
      <h2 class="um-title">用户管理</h2>
      <span class="um-count" v-if="users.length > 0">{{ users.length }} 个用户</span>
    </div>

    <div v-if="error" class="error-state">
      <EmptyState message="加载用户失败" icon="⚠️">
        <el-button type="primary" @click="loadUsers" :loading="loading">
          <el-icon><Refresh /></el-icon>
          重试
        </el-button>
      </EmptyState>
    </div>

    <template v-else>
      <el-table :data="users" style="width: 100%" v-loading="loading" empty-text="暂无用户数据">
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="email" label="邮箱">
          <template #default="{ row }">
            {{ row.email || '未设置' }}
          </template>
        </el-table-column>
        <el-table-column prop="role" label="角色" width="120">
          <template #default="{ row }">
            <el-tag :type="row.role === 'ADMIN' ? 'warning' : 'info'" size="small">
              {{ row.role === 'ADMIN' ? '管理员' : '普通用户' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="注册时间" width="180">
          <template #default="{ row }">
            {{ formatDate(row.createdAt) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200">
          <template #default="{ row }">
            <el-tooltip :content="row.role === 'ADMIN' ? '降级为普通用户' : '升级为管理员'" placement="top">
              <el-button text size="small" @click="toggleRole(row)">
                <el-icon><Switch /></el-icon>
                切换角色
              </el-button>
            </el-tooltip>
            <el-tooltip content="永久删除该用户及其所有数据" placement="top">
              <el-button text size="small" type="danger" @click="deleteUser(row)">
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
    </template>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { adminApi } from '@/api/admin.api'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Refresh, Switch, Delete } from '@element-plus/icons-vue'
import type { User } from '@/types'
import EmptyState from '@/components/common/EmptyState.vue'

const users = ref<User[]>([])
const loading = ref(false)
const error = ref(false)

onMounted(() => {
  loadUsers()
})

async function loadUsers() {
  loading.value = true
  error.value = false
  try {
    users.value = await adminApi.getUsers()
  } catch {
    error.value = true
  } finally {
    loading.value = false
  }
}

async function toggleRole(user: User) {
  try {
    await ElMessageBox.confirm(
      `确定要将"${user.username}"的角色切换为${user.role === 'ADMIN' ? '普通用户' : '管理员'}吗？`,
      '确认切换角色',
      { type: 'warning' }
    )
    const newRole = user.role === 'ADMIN' ? 'USER' : 'ADMIN'
    await adminApi.updateUserRole(user.id, newRole)
    user.role = newRole
    ElMessage.success(`角色已更新为${newRole === 'ADMIN' ? '管理员' : '普通用户'}`)
  } catch {
    // cancelled or error
  }
}

async function deleteUser(user: User) {
  try {
    await ElMessageBox.confirm(
      `确定要永久删除用户"${user.username}"吗？此操作不可撤销，将同时删除该用户的所有笔记数据。`,
      '确认删除用户',
      {
        type: 'warning',
        confirmButtonText: '删除',
        confirmButtonClass: 'el-button--danger',
      }
    )
    await adminApi.deleteUser(user.id)
    users.value = users.value.filter(u => u.id !== user.id)
    ElMessage.success('用户已删除')
  } catch {
    // cancelled or error
  }
}

function formatDate(dateStr: string): string {
  if (!dateStr) return '未知'
  try {
    return new Date(dateStr).toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    })
  } catch {
    return dateStr
  }
}
</script>

<style lang="scss" scoped>
.user-manager {
  max-width: 1000px;
}

.um-header {
  display: flex;
  align-items: baseline;
  gap: var(--space-3);
  margin-bottom: var(--space-4);
}

.um-title {
  font-size: var(--font-size-xl);
  font-weight: 600;
  color: var(--color-text-primary);
}

.um-count {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

.error-state {
  padding: var(--space-12) 0;
}
</style>
