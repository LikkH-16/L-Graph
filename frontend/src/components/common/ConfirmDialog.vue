<template>
  <teleport to="body">
    <transition name="scale-fade">
      <div v-if="visible" class="confirm-overlay" @click.self="onCancel">
        <div class="confirm-dialog">
          <h3 class="confirm-title">{{ title }}</h3>
          <p class="confirm-message">{{ message }}</p>
          <div class="confirm-actions">
            <el-button @click="onCancel">取消</el-button>
            <el-button type="primary" @click="onConfirm" :loading="loading">{{ confirmText }}</el-button>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
  title: string
  message: string
  confirmText?: string
  loading?: boolean
}>()

const emit = defineEmits<{
  confirm: []
  cancel: []
}>()

function onConfirm() { emit('confirm') }
function onCancel() { emit('cancel') }
</script>

<style lang="scss" scoped>
.confirm-overlay {
  position: fixed;
  inset: 0;
  background: var(--color-bg-overlay);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.confirm-dialog {
  width: 400px;
  max-width: calc(100vw - 32px);
  padding: var(--space-6);
  background: var(--color-bg-card);
  border: 1px solid var(--color-border);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-lg);
}

.confirm-title {
  font-size: var(--font-size-lg);
  font-weight: 600;
  color: var(--color-text-primary);
  margin-bottom: var(--space-2);
}

.confirm-message {
  color: var(--color-text-secondary);
  font-size: var(--font-size-sm);
  margin-bottom: var(--space-6);
}

.confirm-actions {
  display: flex;
  justify-content: flex-end;
  gap: var(--space-3);
}
</style>
