<template>
  <div class="admin-layout">
    <aside class="admin-layout__sidebar">
      <div class="admin-layout__logo">
        <span class="admin-layout__brand">L-Graph</span>
        <el-tag type="warning" size="small">Admin</el-tag>
      </div>
      <el-menu
        :default-active="activeMenu"
        router
        class="admin-menu"
        background-color="transparent"
        text-color="var(--color-text-secondary)"
        active-text-color="var(--color-accent-light)"
      >
        <el-tooltip content="系统数据统计概览" placement="right">
          <el-menu-item index="/admin">
            <el-icon><DataAnalysis /></el-icon>
            <span>Dashboard</span>
          </el-menu-item>
        </el-tooltip>
        <el-tooltip content="管理学科标准知识树节点" placement="right">
          <el-menu-item index="/admin/knowledge-tree">
            <el-icon><Collection /></el-icon>
            <span>Knowledge Tree</span>
          </el-menu-item>
        </el-tooltip>
        <el-tooltip content="管理系统用户和角色" placement="right">
          <el-menu-item index="/admin/users">
            <el-icon><User /></el-icon>
            <span>Users</span>
          </el-menu-item>
        </el-tooltip>
      </el-menu>
      <div class="admin-layout__footer">
        <el-tooltip content="返回学科列表" placement="right">
          <el-button text type="info" @click="$router.push('/subjects')">
            <el-icon><ArrowLeft /></el-icon>
            Back to App
          </el-button>
        </el-tooltip>
      </div>
    </aside>
    <main class="admin-layout__content">
      <slot>
        <transition name="page" mode="out-in">
          <router-view />
        </transition>
      </slot>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { DataAnalysis, Collection, User, ArrowLeft } from '@element-plus/icons-vue'

const route = useRoute()
const activeMenu = computed(() => route.path)
</script>

<style lang="scss" scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  overflow: hidden;
  background: var(--color-bg-primary);

  &__sidebar {
    flex-shrink: 0;
    width: 240px;
    height: 100vh;
    border-right: 1px solid var(--color-border);
    background: var(--color-bg-secondary);
    display: flex;
    flex-direction: column;
  }

  &__logo {
    display: flex;
    align-items: center;
    gap: var(--space-3);
    padding: var(--space-5) var(--space-5);
    border-bottom: 1px solid var(--color-border);
  }

  &__brand {
    font-size: var(--font-size-xl);
    font-weight: 700;
    color: var(--color-text-primary);
  }

  &__footer {
    margin-top: auto;
    padding: var(--space-4);
    border-top: 1px solid var(--color-border);
  }

  &__content {
    flex: 1;
    overflow-y: auto;
    padding: var(--space-6);
  }
}

.admin-menu {
  border-right: none !important;
  padding: var(--space-2) 0;
  flex: 1;

  .el-menu-item {
    margin: 2px var(--space-2);
    border-radius: var(--radius-md);
    transition: all var(--transition-fast);
  }

  .el-menu-item.is-active {
    background: rgba(124, 92, 231, 0.15) !important;
  }
}
</style>
