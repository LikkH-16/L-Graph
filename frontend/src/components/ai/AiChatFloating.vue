<template>
  <div class="ai-chat-floating" :style="fabStyle">
    <!-- 悬浮按钮 -->
    <transition name="fade">
      <el-tooltip v-if="!visible" content="AI 学习助教" placement="left">
        <button
          class="ai-fab"
          @mousedown="startDrag"
          @click="openChat"
        >
          <el-icon :size="22"><ChatDotRound /></el-icon>
        </button>
      </el-tooltip>
    </transition>

    <!-- 聊天抽屉 -->
    <transition name="slide-up">
      <div v-if="visible" class="ai-chat-drawer glass-panel" :style="drawerStyle">
        <!-- 拖拽手柄 -->
        <div class="chat-header" @mousedown="startDrag">
          <span class="chat-header__title">
            <el-icon><ChatDotRound /></el-icon> AI 助教
          </span>
          <span class="chat-header__model">DeepSeek</span>
          <el-button text size="small" @mousedown.stop class="chat-header__new" @click="newSession">
            <el-icon :size="14"><Plus /></el-icon>
          </el-button>
          <el-button text size="small" @mousedown.stop @click="visible = false">
            <el-icon :size="16"><Close /></el-icon>
          </el-button>
        </div>

        <!-- 会话列表（折叠） -->
        <div v-if="sessions.length > 1" class="chat-sessions">
          <div
            v-for="sess in sessions"
            :key="sess.id"
            class="session-item"
            :class="{ active: sess.id === currentSessionId }"
            @click="switchSession(sess.id)"
          >
            <span class="session-item__title">{{ sess.title || '新对话' }}</span>
            <span class="session-item__time">{{ formatTime(sess.createdAt) }}</span>
            <el-button text size="small" class="session-item__del" @click.stop="deleteSession(sess.id)">
              <el-icon :size="12"><Close /></el-icon>
            </el-button>
          </div>
        </div>

        <!-- 消息区 -->
        <div class="chat-messages" ref="msgContainer">
          <!-- 时间标签 -->
          <div
            v-for="(group, gi) in timeGroups"
            :key="gi"
            class="time-group"
          >
            <div class="time-divider">{{ group.label }}</div>
            <div v-for="(msg, i) in group.messages" :key="i" class="chat-msg" :class="'msg-' + msg.role">
              <div class="msg-avatar">
                <el-icon v-if="msg.role === 'assistant'" :size="16"><ChatDotRound /></el-icon>
                <el-icon v-else :size="16"><User /></el-icon>
              </div>
              <div class="msg-bubble">
                <div class="msg-content" v-html="renderMd(msg.content)"></div>
                <div class="msg-time">{{ msg.time }}</div>
              </div>
            </div>
          </div>

          <div v-if="currentMessages.length === 0 && !sending" class="chat-welcome">
            <p>👋 你好！我是 L-Graph AI 助教。</p>
            <p>可以问我关于 <strong>数据结构、计组、操作系统、计算机网络</strong> 的任何问题。</p>
          </div>

          <div v-if="sending" class="chat-msg msg-assistant">
            <div class="msg-avatar"><el-icon :size="16"><ChatDotRound /></el-icon></div>
            <div class="msg-content typing">思考中<span class="dots"></span></div>
          </div>
        </div>

        <!-- 输入区 -->
        <div class="chat-input">
          <el-input
            v-model="input"
            placeholder="输入你的问题..."
            :disabled="sending"
            @keydown.enter.exact="sendMessage"
            size="default"
          >
            <template #append>
              <el-button :disabled="!input.trim() || sending" @click="sendMessage">
                <el-icon><Promotion /></el-icon>
              </el-button>
            </template>
          </el-input>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, nextTick, watch, onUnmounted } from 'vue'
import { ChatDotRound, Close, User, Promotion, Plus } from '@element-plus/icons-vue'
import { aiApi } from '@/api/ai.api'

interface Msg {
  role: 'user' | 'assistant'
  content: string
  time: string
}
interface Session {
  id: string
  title: string
  createdAt: number
  messages: Msg[]
}

const STORAGE_KEY = 'lgraph_ai_sessions'

function loadSessions(): Session[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? JSON.parse(raw) : []
  } catch { return [] }
}
function saveSessions(arr: Session[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(arr))
}

const visible = ref(false)
const input = ref('')
const sending = ref(false)
const msgContainer = ref<HTMLElement | null>(null)
const sessions = ref<Session[]>(loadSessions())
const currentSessionId = ref(sessions.value[0]?.id || '')

// 拖拽状态
const pos = reactive({ x: -1, y: -1 })
const dragging = ref(false)
let dragStart = { x: 0, y: 0, elX: 0, elY: 0 }
let dragMoved = false

function initPos() {
  if (pos.x < 0) {
    pos.x = window.innerWidth - 76
    pos.y = window.innerHeight - 150
  }
}
initPos()

/** 悬浮按钮定位 */
const fabStyle = computed(() => ({
  left: pos.x + 'px',
  top: pos.y + 'px',
}))

/** 抽屉智能定位：独立 fixed 定位，基于 fab 位置避免超出视口 */
const DRAWER_W = 400
const DRAWER_H = 560
const FAB_SIZE = 52
const drawerStyle = computed(() => {
  let left = pos.x
  let top = pos.y + FAB_SIZE + 6
  // 右半屏：向左弹出
  if (pos.x + DRAWER_W > window.innerWidth - 10) {
    left = Math.max(10, pos.x + FAB_SIZE - DRAWER_W)
  }
  // 下半屏：向上弹出
  if (top + DRAWER_H > window.innerHeight - 10) {
    top = Math.max(10, pos.y - DRAWER_H - 6)
  }
  return {
    position: 'fixed',
    left: left + 'px',
    top: top + 'px',
  }
})

function startDrag(e: MouseEvent) {
  if ((e.target as HTMLElement).closest('button, .el-button') && !(e.target as HTMLElement).classList.contains('ai-fab')) return
  dragging.value = true
  dragMoved = false
  dragStart = { x: e.clientX, y: e.clientY, elX: pos.x, elY: pos.y }
  document.addEventListener('mousemove', onDrag)
  document.addEventListener('mouseup', stopDrag)
}
function onDrag(e: MouseEvent) {
  const dx = e.clientX - dragStart.x
  const dy = e.clientY - dragStart.y
  if (Math.abs(dx) > 3 || Math.abs(dy) > 3) dragMoved = true
  pos.x = Math.max(0, Math.min(window.innerWidth - 60, dragStart.elX + dx))
  pos.y = Math.max(0, Math.min(window.innerHeight - 60, dragStart.elY + dy))
}
function stopDrag() {
  dragging.value = false
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
}
onUnmounted(() => {
  document.removeEventListener('mousemove', onDrag)
  document.removeEventListener('mouseup', stopDrag)
})

// 当前会话
const currentSession = computed(() => sessions.value.find(s => s.id === currentSessionId.value))
const currentMessages = computed(() => currentSession.value?.messages || [])

// 按时间分组（同一天归一组）
const timeGroups = computed(() => {
  const msgs = currentMessages.value
  if (!msgs.length) return []
  const groups: { label: string; messages: Msg[] }[] = []
  let lastDate = ''
  for (const m of msgs) {
    const date = m.time.substring(0, 10)
    if (date !== lastDate) {
      lastDate = date
      groups.push({ label: date, messages: [] })
    }
    groups[groups.length - 1].messages.push(m)
  }
  return groups
})

function openChat() {
  if (dragMoved) { dragMoved = false; return }
  visible.value = true
  ensureSession()
  nextTick(() => scrollToBottom())
}

function ensureSession() {
  if (!currentSessionId.value || !sessions.value.find(s => s.id === currentSessionId.value)) {
    newSession()
  }
}

function newSession() {
  const id = Date.now().toString(36) + Math.random().toString(36).slice(2, 6)
  const session: Session = {
    id,
    title: '',
    createdAt: Date.now(),
    messages: [],
  }
  sessions.value.unshift(session)
  currentSessionId.value = id
  saveSessions(sessions.value)
}

function switchSession(id: string) {
  currentSessionId.value = id
  nextTick(() => scrollToBottom())
}

function deleteSession(id: string) {
  sessions.value = sessions.value.filter(s => s.id !== id)
  if (currentSessionId.value === id) {
    currentSessionId.value = sessions.value[0]?.id || ''
  }
  if (!currentSessionId.value) newSession()
  saveSessions(sessions.value)
}

watch(visible, (v) => {
  if (v) { ensureSession(); nextTick(() => scrollToBottom()) }
})

async function sendMessage() {
  const text = input.value.trim()
  if (!text || sending.value) return
  ensureSession()
  const now = new Date()
  const timeStr = now.toLocaleString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  const msg: Msg = { role: 'user', content: text, time: timeStr }
  currentSession.value!.messages.push(msg)
  if (!currentSession.value!.title) {
    currentSession.value!.title = text.slice(0, 20)
  }
  input.value = ''
  sending.value = true
  saveSessions(sessions.value)
  nextTick(() => scrollToBottom())

  try {
    const history: { role: string; content: string }[] = currentSession.value!.messages
      .slice(0, -1)
      .map(m => ({ role: m.role, content: m.content }))
    const res = await aiApi.chat({ message: text, history })
    const replyTime = new Date().toLocaleString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    currentSession.value!.messages.push({ role: 'assistant', content: res.reply, time: replyTime })
    saveSessions(sessions.value)
  } catch {
    currentSession.value!.messages.push({
      role: 'assistant',
      content: '抱歉，AI 服务暂时不可用。',
      time: new Date().toLocaleString('zh-CN', { hour: '2-digit', minute: '2-digit' })
    })
  } finally {
    sending.value = false
    saveSessions(sessions.value)
    nextTick(() => scrollToBottom())
  }
}

function scrollToBottom() {
  const el = msgContainer.value
  if (el) el.scrollTop = el.scrollHeight
}

function formatTime(ts: number): string {
  const d = new Date(ts)
  const now = new Date()
  const diff = now.getTime() - d.getTime()
  if (diff < 86400000) return d.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  if (diff < 604800000) return Math.floor(diff / 86400000) + '天前'
  return d.toLocaleDateString('zh-CN')
}

function renderMd(text: string): string {
  return text
    .replace(/```(\w*)\n([\s\S]*?)```/g, '<pre><code>$2</code></pre>')
    .replace(/`(.+?)`/g, '<code>$1</code>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/\n/g, '<br>')
}
</script>

<style lang="scss" scoped>
.ai-chat-floating {
  position: fixed;
  z-index: var(--z-overlay);
}

/* 悬浮按钮 */
.ai-fab {
  width: 52px; height: 52px;
  border-radius: 50%;
  border: none;
  background: linear-gradient(135deg, #7c5ce7, #4f46e5);
  color: #fff;
  cursor: grab;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 4px 16px rgba(124, 92, 231, 0.4);
  transition: transform var(--transition-bounce);
  &:hover { transform: scale(1.08); }
  &:active { cursor: grabbing; }
}

/* 聊天抽屉 */
.ai-chat-drawer {
  width: 400px; height: 560px;
  display: flex; flex-direction: column;
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: var(--shadow-lg);
  z-index: calc(var(--z-overlay) + 1);
}

.chat-header {
  display: flex; align-items: center; gap: var(--space-2);
  padding: var(--space-2) var(--space-3);
  border-bottom: 1px solid var(--color-border);
  background: linear-gradient(135deg, rgba(124, 92, 231, 0.08), transparent);
  flex-shrink: 0;
  cursor: grab;
  &:active { cursor: grabbing; }

  &__title {
    flex: 1; display: flex; align-items: center; gap: var(--space-2);
    font-size: var(--font-size-sm); font-weight: 600;
    color: var(--color-text-primary);
  }
  &__model {
    font-size: 11px; color: var(--color-accent-light);
    background: var(--color-bg-card); padding: 1px 6px;
    border-radius: var(--radius-sm);
  }
  &__new {
    color: var(--color-text-muted) !important;
    &:hover { color: var(--color-accent-light) !important; }
  }
}

/* 会话列表 */
.chat-sessions {
  max-height: 120px;
  overflow-y: auto;
  border-bottom: 1px solid var(--color-border);
  background: var(--color-bg-primary);
  flex-shrink: 0;
}

.session-item {
  display: flex; align-items: center; gap: var(--space-2);
  padding: var(--space-2) var(--space-3);
  cursor: pointer;
  font-size: var(--font-size-xs);
  transition: background var(--transition-fast);

  &:hover { background: var(--color-bg-card-hover); }
  &.active { background: rgba(124, 92, 231, 0.08); }

  &__title {
    flex: 1; color: var(--color-text-primary);
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
  }
  &__time { color: var(--color-text-muted); flex-shrink: 0; }
  &__del { opacity: 0; color: var(--color-text-muted) !important; }
  &:hover &__del { opacity: 1; }
}

/* 消息区 */
.chat-messages {
  flex: 1; overflow-y: auto;
  padding: var(--space-3);
  display: flex; flex-direction: column;
}

.chat-welcome {
  text-align: center; color: var(--color-text-muted);
  font-size: var(--font-size-sm); padding: var(--space-6) 0; line-height: 1.8;
  margin: auto;
}

.time-group { display: contents; }

.time-divider {
  text-align: center;
  font-size: 11px;
  color: var(--color-text-muted);
  padding: var(--space-2) 0;
  &::before { content: '—— '; }
  &::after { content: ' ——'; }
}

.chat-msg {
  display: flex; gap: var(--space-2);
  max-width: 90%; margin-bottom: var(--space-2);

  &.msg-user {
    align-self: flex-end; flex-direction: row-reverse;
    .msg-avatar { background: var(--color-accent); }
    .msg-bubble {
      align-items: flex-end;
      .msg-content {
        background: rgba(124, 92, 231, 0.12);
        border: 1px solid rgba(124, 92, 231, 0.2);
      }
    }
  }
  &.msg-assistant {
    .msg-avatar { background: var(--color-success); }
    .msg-bubble .msg-content {
      background: var(--color-bg-card);
      border: 1px solid var(--color-border);
    }
  }
}

.msg-avatar {
  width: 28px; height: 28px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  color: #fff; flex-shrink: 0; font-size: 14px;
}

.msg-bubble {
  display: flex; flex-direction: column; gap: 2px;
}

.msg-content {
  padding: var(--space-2) var(--space-3);
  border-radius: var(--radius-md);
  font-size: var(--font-size-sm); color: var(--color-text-primary);
  line-height: 1.6; word-break: break-word;

  :deep(pre) {
    background: var(--color-bg-primary); padding: var(--space-2);
    border-radius: var(--radius-sm); overflow-x: auto;
    font-size: var(--font-size-xs); margin: var(--space-1) 0;
  }
  :deep(code) {
    background: var(--color-bg-primary); padding: 1px 4px;
    border-radius: 3px; font-size: var(--font-size-xs);
  }
  :deep(strong) { color: var(--color-accent-light); }
}

.msg-time {
  font-size: 10px; color: var(--color-text-muted); padding: 0 var(--space-1);
}

.msg-user .msg-time { text-align: right; }

.typing .dots::after {
  content: ''; animation: dots 1.4s infinite;
}
@keyframes dots {
  0%,20%{ content:''; } 40%{ content:'.'; } 60%{ content:'..'; } 80%,100%{ content:'...'; }
}

/* 输入区 */
.chat-input {
  padding: var(--space-3); border-top: 1px solid var(--color-border);
  flex-shrink: 0;
}

/* 过渡动画 */
.slide-up-enter-active, .slide-up-leave-active { transition: all 0.25s ease; }
.slide-up-enter-from, .slide-up-leave-to { opacity: 0; transform: translateY(16px) scale(0.95); }
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
