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
// Reveal.js black theme
.reveal-viewport {
  background: #191919;
  background-color: #191919;
}

.reveal {
  font-family: 'Inter', -apple-system, sans-serif;
  font-size: 40px;
  font-weight: normal;
  color: #fff;
}

.reveal ::selection {
  color: #fff;
  background: rgba(124, 92, 231, 0.6);
}

.reveal h1, .reveal h2, .reveal h3, .reveal h4, .reveal h5, .reveal h6 {
  color: #fff;
  font-weight: 600;
}

.reveal h1 { font-size: 2.5em; }
.reveal h2 { font-size: 1.6em; }
.reveal h3 { font-size: 1.3em; }
.reveal h4 { font-size: 1em; }

.reveal p { margin: 20px 0; line-height: 1.3; }

.reveal a { color: #9d7ff2; }

.reveal pre {
  display: block;
  position: relative;
  width: 90%;
  margin: 20px auto;
  text-align: left;
  font-size: 0.55em;
  font-family: 'JetBrains Mono', monospace;
  line-height: 1.2em;
  word-wrap: break-word;
  box-shadow: 0px 5px 15px rgba(0, 0, 0, 0.15);
}

.reveal code {
  font-family: 'JetBrains Mono', monospace;
}

.reveal pre code {
  display: block;
  padding: 15px;
  overflow: auto;
  max-height: 400px;
  word-wrap: normal;
  background: #0d1117;
  color: #c9d1d9;
}

.reveal table {
  margin: auto;
  border-collapse: collapse;
  border-spacing: 0;
}

.reveal table th { font-weight: bold; }

.reveal table th, .reveal table td {
  text-align: left;
  padding: 0.2em 0.5em;
  border-bottom: 1px solid;
}

.reveal table th[align='center'], .reveal table td[align='center'] { text-align: center; }
.reveal table th[align='right'], .reveal table td[align='right'] { text-align: right; }

.reveal table tbody tr:last-child th, .reveal table tbody tr:last-child td {
  border-bottom: none;
}

.reveal .slides section { height: 100%; display: flex; flex-direction: column; justify-content: center; }
.reveal ul, .reveal ol { display: block; text-align: left; }
.reveal ol { list-style-type: decimal; }
.reveal ul { list-style-type: disc; }
.reveal ul ul { list-style-type: square; }
.reveal ul ul ul { list-style-type: circle; }
.reveal blockquote {
  display: block;
  position: relative;
  width: 70%;
  margin: 20px auto;
  padding: 5px;
  font-style: italic;
  background: rgba(255, 255, 255, 0.05);
  box-shadow: 0px 0px 2px rgba(0, 0, 0, 0.2);
}
.reveal blockquote p:first-child, .reveal blockquote p:last-child {
  display: inline-block;
}
</style>
