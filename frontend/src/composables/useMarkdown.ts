import { ref, onUnmounted } from 'vue'
import Vditor from 'vditor'
import 'vditor/dist/index.css'

export function useMarkdown() {
  const vditor = ref<Vditor | null>(null)
  const content = ref('')
  const isReady = ref(false)

  function init(container: HTMLElement, initialContent = '', cacheId?: string) {
    content.value = initialContent
    vditor.value = new Vditor(container, {
      height: '100%',
      mode: 'ir',
      theme: 'dark',
      content: initialContent,
      placeholder: '开始编写笔记... 支持 Markdown、LaTeX 公式和代码高亮',
      cache: {
        enable: !!cacheId,
        id: cacheId || '',
      },
      preview: {
        theme: { current: 'dark' },
        hljs: { style: 'github-dark' },
        math: { engine: 'KaTeX' },
      },
      toolbar: [
        'headings', 'bold', 'italic', 'strike', '|',
        'line', 'quote', 'list', 'ordered-list', 'check', 'code', 'inline-code', '|',
        'table', 'link', '|',
        'undo', 'redo', '|',
        'fullscreen',
      ],
      upload: {
        accept: 'image/*',
        async handler(files: File[]) {
          // Convert to base64 data URLs for local use (no dedicated image server yet)
          const results: string[] = []
          for (const file of files) {
            const url = await new Promise<string>((resolve, reject) => {
              const reader = new FileReader()
              reader.onload = () => resolve(reader.result as string)
              reader.onerror = () => reject(new Error('Failed to read image'))
              reader.readAsDataURL(file)
            })
            results.push(url)
          }
          // Vditor expects the handler to return the uploaded URL string
          // For multiple files, return the first one (Vditor calls handler once per paste/drop)
          return results[0]
        },
      },
      after() {
        isReady.value = true
      },
      input(value: string) {
        content.value = value
      },
    })
  }

  function getValue(): string {
    return vditor.value?.getValue() || content.value
  }

  function setValue(md: string) {
    content.value = md
    vditor.value?.setValue(md)
  }

  function destroy() {
    vditor.value?.destroy()
    vditor.value = null
    isReady.value = false
  }

  onUnmounted(() => {
    destroy()
  })

  return { vditor, content, isReady, init, getValue, setValue, destroy }
}
