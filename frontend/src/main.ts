import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import 'element-plus/dist/index.css'
import 'katex/dist/katex.min.css'

import App from './App.vue'
import router from './router'
import './assets/styles/global.scss'
import './assets/styles/transitions.scss'
import './assets/styles/markdown.scss'
import './assets/styles/graph.scss'

const app = createApp(App)

for (const [key, component] of Object.entries(ElementPlusIconsVue)) {
  app.component(key, component)
}

const pinia = createPinia()
app.use(pinia)
app.use(router)
app.use(ElementPlus)

app.mount('#app')
