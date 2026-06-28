<template>
  <div class="slide-renderer">
    <div ref="revealContainer" class="reveal-container"></div>
    <SlideControls
      :slide-count="slideCount"
      :current-slide="currentSlide"
      @prev="prevSlide"
      @next="nextSlide"
      @exit="$emit('exit')"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import Reveal from 'reveal.js'
import 'reveal.js/reveal.css'
import SlideControls from './SlideControls.vue'

const props = defineProps<{
  html: string
}>()

defineEmits<{
  exit: []
}>()

const revealContainer = ref<HTMLElement | null>(null)
const slideCount = ref(0)
const currentSlide = ref(1)

let deck: Reveal.Api | null = null

onMounted(async () => {
  if (!revealContainer.value) return
  revealContainer.value.innerHTML = props.html

  deck = new Reveal(revealContainer.value, {
    hash: false,
    transition: 'slide',
    backgroundTransition: 'fade',
    controls: false,
    progress: false,
    center: true,
    width: 1200,
    height: 700,
    margin: 0.1,
  })

  await deck.initialize()

  slideCount.value = deck.getTotalSlides()

  deck.on('slidechanged', (event: { indexh: number; indexv: number }) => {
    currentSlide.value = event.indexh + 1 + event.indexv
  })
})

function prevSlide() { deck?.prev() }
function nextSlide() { deck?.next() }

onUnmounted(() => {
  deck?.destroy()
})
</script>

<style lang="scss" scoped>
.slide-renderer {
  width: 100vw;
  height: 100vh;
  position: relative;
  background: #000;
}

.reveal-container {
  width: 100%;
  height: 100%;
}
</style>

<style lang="scss">
/* === Modern Dark Theme for Reveal.js === */
:root {
  --slide-bg: #0b0f19;
  --slide-accent: #818cf8;
  --slide-accent2: #22d3ee;
  --slide-success: #34d399;
  --slide-warning: #fbbf24;
  --slide-danger: #f87171;
}

.reveal-viewport {
  background: radial-gradient(ellipse at 30% 20%, #1e1b4b 0%, #0b0f19 60%) !important;
  background-color: var(--slide-bg) !important;
}

.reveal {
  font-family: 'Inter', -apple-system, sans-serif;
  font-size: 40px;
  font-weight: normal;
  color: #e2e8f0;
}

.reveal ::selection {
  color: #fff;
  background: rgba(129, 140, 248, 0.4);
}

.reveal h1, .reveal h2, .reveal h3, .reveal h4, .reveal h5, .reveal h6 {
  color: #f1f5f9;
  font-weight: 700;
  letter-spacing: -0.02em;
}

.reveal h1 {
  font-size: 2.8em;
  background: linear-gradient(135deg, var(--slide-accent), var(--slide-accent2));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.reveal h2 { font-size: 1.8em; color: var(--slide-accent); }
.reveal h3 { font-size: 1.4em; }
.reveal h4 { font-size: 1.1em; }

.reveal p {
  margin: 20px 0;
  line-height: 1.5;
  color: #cbd5e1;
}

.reveal a {
  color: var(--slide-accent2);
  text-decoration: none;
  transition: opacity 0.2s;
  &:hover { opacity: 0.8; }
}

.reveal strong { color: #f1f5f9; font-weight: 700; }
.reveal em { color: var(--slide-warning); font-style: italic; }

.reveal pre {
  display: block;
  position: relative;
  width: 90%;
  margin: 20px auto;
  text-align: left;
  font-size: 0.55em;
  font-family: 'JetBrains Mono', 'Cascadia Code', monospace;
  line-height: 1.5em;
  word-wrap: break-word;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.4), 0 0 0 1px rgba(255,255,255,0.05) inset;
}

.reveal code {
  font-family: 'JetBrains Mono', 'Cascadia Code', monospace;
  color: #fbbf24;
}

.reveal pre code {
  display: block;
  padding: 20px 24px;
  overflow: auto;
  max-height: 400px;
  word-wrap: normal;
  background: #0d1117;
  color: #c9d1d9;
  border-radius: 12px;
}

.reveal table {
  margin: auto;
  border-collapse: collapse;
  border-spacing: 0;
}

.reveal table th {
  font-weight: bold;
  background: rgba(129, 140, 248, 0.1);
}

.reveal table th, .reveal table td {
  text-align: left;
  padding: 0.3em 0.6em;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}

.reveal table th[align='center'], .reveal table td[align='center'] { text-align: center; }
.reveal table th[align='right'], .reveal table td[align='right'] { text-align: right; }

.reveal table tbody tr:last-child th, .reveal table tbody tr:last-child td {
  border-bottom: none;
}

.reveal .slides section {
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.reveal ul, .reveal ol {
  display: block;
  text-align: left;
  color: #cbd5e1;
}
.reveal ol { list-style-type: decimal; }
.reveal ul { list-style-type: disc; }
.reveal ul ul { list-style-type: square; }
.reveal ul ul ul { list-style-type: circle; }

.reveal li { margin: 8px 0; }

.reveal blockquote {
  display: block;
  position: relative;
  width: 75%;
  margin: 20px auto;
  padding: 16px 24px;
  font-style: italic;
  background: rgba(129, 140, 248, 0.06);
  border-left: 4px solid var(--slide-accent);
  border-radius: 0 8px 8px 0;
  color: #94a3b8;
}
.reveal blockquote p:first-child, .reveal blockquote p:last-child {
  display: inline-block;
}

.reveal .math {
  color: var(--slide-accent2);
}
</style>
