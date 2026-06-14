import type { Page } from '@/types'

export function useSlide() {
  function buildSlides(pages: Page[]): string {
    if (pages.length === 0) return '<section><h2>暂无内容</h2></section>'

    const sections = pages.map(page => {
      const parts = page.content.split('---')
      if (parts.length === 1) {
        return `<section>
          <h2>${escapeHtml(page.title)}</h2>
          ${mdToHtml(parts[0])}
        </section>`
      }

      const [main, ...subParts] = parts
      return `<section>
        <section>
          <h2>${escapeHtml(page.title)}</h2>
          ${mdToHtml(main)}
        </section>
        ${subParts.map(sub => `<section>${mdToHtml(sub)}</section>`).join('')}
      </section>`
    })

    return `<div class="slides">${sections.join('')}</div>`
  }

  return { buildSlides }
}

function escapeHtml(text: string): string {
  return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
}

function mdToHtml(md: string): string {
  return md
    .replace(/^### (.+)$/gm, '<h3>$1</h3>')
    .replace(/^## (.+)$/gm, '<h2>$1</h2>')
    .replace(/^# (.+)$/gm, '<h1>$1</h1>')
    .replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.+?)\*/g, '<em>$1</em>')
    .replace(/`(.+?)`/g, '<code>$1</code>')
    .replace(/^\- (.+)$/gm, '<li>$1</li>')
    .replace(/(<li>.*<\/li>)/s, (match) => `<ul>${match}</ul>`)
    .replace(/\n\n/g, '</p><p>')
    .replace(/^(?!<[hulc/])/gm, '<p>')
    .replace(/([^>])$/gm, '$1</p>')
    .replace(/```(\w+)?\n([\s\S]*?)```/g, '<pre><code class="language-$1">$2</code></pre>')
    .replace(/\$\$([\s\S]*?)\$\$/g, '<div class="math">$$$1$$</div>')
    .replace(/\$(.+?)\$/g, '<span class="math">$$$1$$</span>')
}
