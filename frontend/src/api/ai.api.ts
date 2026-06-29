import { post } from './client'

interface AiChatParams {
  message: string
  history?: { role: string; content: string }[]
}

interface AiChatResult {
  reply: string
}

export const aiApi = {
  async chat(data: AiChatParams): Promise<AiChatResult> {
    return post<AiChatResult>('/ai/chat', data)
  },
}
