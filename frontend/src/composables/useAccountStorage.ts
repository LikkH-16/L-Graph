import { ref } from 'vue'

const STORAGE_KEY = 'lgraph_saved_accounts'
const MAX_ACCOUNTS = 3

export interface SavedAccount {
  username: string
  password?: string  // 仅当用户选择记住密码时才保存
  lastLoginAt: number
}

function loadAll(): SavedAccount[] {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return []
    const arr = JSON.parse(raw)
    if (!Array.isArray(arr)) return []
    return arr as SavedAccount[]
  } catch {
    return []
  }
}

function saveAll(accounts: SavedAccount[]) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(accounts.slice(0, MAX_ACCOUNTS)))
}

export function useAccountStorage() {
  const savedAccounts = ref<SavedAccount[]>(loadAll())

  /** 登录成功时调用：把账号写入/更新到列表最前面，最多保留 MAX_ACCOUNTS 个 */
  function saveAccount(username: string, password?: string) {
    const list = loadAll()
    // 大小写不敏感：移除同名旧记录（保留用户输入的原始大小写用于展示）
    const lower = username.toLowerCase()
    const filtered = list.filter(a => a.username.toLowerCase() !== lower)
    // 插入到最前面
    const entry: SavedAccount = {
      username,
      password,
      lastLoginAt: Date.now(),
    }
    const updated = [entry, ...filtered]
    saveAll(updated)
    savedAccounts.value = updated
  }

  /** 删除某个已保存的账号 */
  function removeAccount(username: string) {
    const lower = username.toLowerCase()
    const list = loadAll().filter(a => a.username.toLowerCase() !== lower)
    saveAll(list)
    savedAccounts.value = list
  }

  /** 刷新内存中的列表 */
  function refresh() {
    savedAccounts.value = loadAll()
  }

  return { savedAccounts, saveAccount, removeAccount, refresh }
}
