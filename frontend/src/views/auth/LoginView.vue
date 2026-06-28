<template>
  <div class="login-view">
    <h2 class="login-title">欢迎回来</h2>
    <p class="login-subtitle">登录以继续你的学习之旅</p>
    <el-form ref="formRef" :model="form" :rules="rules" size="large" @submit.prevent="onSubmit">
      <!-- 用户名输入框 + 保存账号下拉 -->
      <el-form-item prop="username">
        <div class="username-wrap">
          <el-input
            ref="usernameInputRef"
            v-model="form.username"
            placeholder="用户名"
            :prefix-icon="User"
            @focus="onUsernameFocus"
            @blur="onUsernameBlur"
            @input="onUsernameInput"
            autocomplete="off"
          />
          <!-- 已保存账号下拉面板 -->
          <transition name="fade">
            <div
              v-if="showAccountPanel && accountList.length > 0"
              class="account-panel glass-panel"
            >
              <p class="account-panel__hint">已保存的账号</p>
              <div
                v-for="acc in accountList"
                :key="acc.username"
                class="account-item"
                @mousedown.prevent="selectAccount(acc)"
              >
                <div class="account-item__avatar">
                  <el-icon :size="18"><UserFilled /></el-icon>
                </div>
                <div class="account-item__info">
                  <span class="account-item__name">{{ acc.username }}</span>
                  <span v-if="acc.password" class="account-item__saved">
                    <el-icon :size="12"><Lock /></el-icon> 密码已保存
                  </span>
                </div>
                <el-button
                  text
                  size="small"
                  class="account-item__delete"
                  @mousedown.stop
                  @click.stop="removeSaved(acc.username)"
                >
                  <el-icon :size="14"><Close /></el-icon>
                </el-button>
              </div>
            </div>
          </transition>
        </div>
      </el-form-item>

      <!-- 密码输入框 -->
      <el-form-item prop="password">
        <el-input
          v-model="form.password"
          type="password"
          placeholder="密码"
          show-password
          :prefix-icon="Lock"
          autocomplete="off"
        />
      </el-form-item>

      <!-- 记住密码 -->
      <el-form-item class="remember-row">
        <el-checkbox v-model="rememberPassword" size="small">记住密码</el-checkbox>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" native-type="submit" :loading="loading" style="width: 100%">
          登录
        </el-button>
      </el-form-item>
    </el-form>
    <p class="login-link">
      还没有账号？<router-link to="/register">立即注册</router-link>
    </p>
  </div>
</template>

<script setup lang="ts">
import { reactive, ref, computed, watch, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { User, Lock, UserFilled, Close } from '@element-plus/icons-vue'
import { useAuthStore } from '@/stores/auth.store'
import { useAccountStorage } from '@/composables/useAccountStorage'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'

const router = useRouter()
const authStore = useAuthStore()
const accountStore = useAccountStorage()
const formRef = ref<FormInstance>()
const usernameInputRef = ref()
const loading = ref(false)
const rememberPassword = ref(false)
const showAccountPanel = ref(false)

const form = reactive({
  username: '',
  password: '',
})

const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
}

/** 过滤后的账号列表：输入框有内容时只显示匹配的 */
const accountList = computed(() => {
  const keyword = form.username.trim().toLowerCase()
  if (!keyword) return accountStore.savedAccounts.value.slice(0, 3)
  return accountStore.savedAccounts.value
    .filter(a => a.username.toLowerCase().includes(keyword))
    .slice(0, 3)
})

function onUsernameFocus() {
  accountStore.refresh()
  showAccountPanel.value = true
}

function onUsernameBlur() {
  // 延迟关闭，让 mousedown 有机会触发
  setTimeout(() => {
    showAccountPanel.value = false
  }, 150)
}

function onUsernameInput() {
  accountStore.refresh()
  showAccountPanel.value = true
}

function selectAccount(acc: { username: string; password?: string }) {
  form.username = acc.username
  if (acc.password) {
    form.password = acc.password
    rememberPassword.value = true
  } else {
    form.password = ''
    rememberPassword.value = false
  }
  showAccountPanel.value = false
  // 自动聚焦到密码框
  nextTick(() => {
    const pwdInput = document.querySelector('.el-input[type="password"] input') as HTMLInputElement
    pwdInput?.focus()
  })
}

function removeSaved(username: string) {
  accountStore.removeAccount(username)
}

async function onSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    await authStore.login(form)
    // 登录成功后保存账户
    const savedPwd = rememberPassword.value ? form.password : undefined
    accountStore.saveAccount(form.username, savedPwd)
    ElMessage.success('登录成功')
    router.push('/subjects')
  } catch {
    ElMessage.error('登录失败，请检查用户名和密码')
  } finally {
    loading.value = false
  }
}
</script>

<style lang="scss" scoped>
.login-title {
  font-size: var(--font-size-2xl);
  font-weight: 700;
  color: var(--color-text-primary);
  text-align: center;
  margin-bottom: var(--space-2);
}

.login-subtitle {
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
  text-align: center;
  margin-bottom: var(--space-8);
}

.login-link {
  text-align: center;
  font-size: var(--font-size-sm);
  color: var(--color-text-muted);
}

/* ---- 账号下拉面板 ---- */
.username-wrap {
  width: 100%;
}

.account-panel {
  margin-top: 4px;
  padding: var(--space-2);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-md);
}

.account-panel__hint {
  font-size: var(--font-size-xs);
  color: var(--color-text-muted);
  padding: 2px var(--space-2);
  margin-bottom: var(--space-1);
}

.account-item {
  display: flex;
  align-items: center;
  gap: var(--space-2);
  padding: var(--space-2) var(--space-2);
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: background var(--transition-fast);

  &:hover {
    background: var(--color-bg-card-hover);
  }

  &__avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    background: rgba(124, 92, 231, 0.12);
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--color-accent-light);
    flex-shrink: 0;
  }

  &__info {
    flex: 1;
    min-width: 0;
    display: flex;
    flex-direction: column;
    gap: 1px;
  }

  &__name {
    font-size: var(--font-size-sm);
    color: var(--color-text-primary);
    font-weight: 500;
  }

  &__saved {
    font-size: 11px;
    color: var(--color-text-muted);
    display: flex;
    align-items: center;
    gap: 2px;
  }

  &__delete {
    color: var(--color-text-muted) !important;
    flex-shrink: 0;
    opacity: 0;
    transition: opacity var(--transition-fast);

    &:hover {
      color: var(--color-danger) !important;
    }
  }

  &:hover &__delete {
    opacity: 1;
  }
}

.remember-row {
  margin-bottom: var(--space-3);
}

.fade-enter-active, .fade-leave-active {
  transition: opacity var(--transition-fast);
}
.fade-enter-from, .fade-leave-to {
  opacity: 0;
}
</style>
