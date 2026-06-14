import type { RouteRecordRaw } from 'vue-router'

export const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/subjects',
  },
  // Auth
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/auth/LoginView.vue'),
    meta: { layout: 'auth', guest: true },
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import('@/views/auth/RegisterView.vue'),
    meta: { layout: 'auth', guest: true },
  },
  // Subjects
  {
    path: '/subjects',
    name: 'Subjects',
    component: () => import('@/views/subjects/SubjectListView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  {
    path: '/subjects/:subjectId',
    name: 'SubjectDetail',
    component: () => import('@/views/subjects/SubjectDetailView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  // Note & Page editing
  {
    path: '/subjects/:subjectId/notes/:noteId',
    name: 'NoteEditor',
    component: () => import('@/views/note/NoteEditorView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  {
    path: '/subjects/:subjectId/pages/:pageId',
    name: 'PageEditor',
    component: () => import('@/views/note/PageEditorView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  // Graph
  {
    path: '/subjects/:subjectId/graph',
    name: 'GraphExplorer',
    component: () => import('@/views/graph/GraphExplorerView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  // Slide
  {
    path: '/subjects/:subjectId/slides',
    name: 'SlideShow',
    component: () => import('@/views/slide/SlideShowView.vue'),
    meta: { layout: 'blank', requiresAuth: true },
  },
  // Review
  {
    path: '/review/:subjectId',
    name: 'ReviewProgress',
    component: () => import('@/views/review/ReviewProgressView.vue'),
    meta: { layout: 'main', requiresAuth: true },
  },
  // Admin
  {
    path: '/admin',
    component: () => import('@/components/layout/AdminLayout.vue'),
    meta: { requiresAuth: true, requiresAdmin: true },
    children: [
      { path: '', name: 'AdminDashboard', component: () => import('@/views/admin/AdminDashboardView.vue') },
      { path: 'knowledge-tree', name: 'KnowledgeTreeManager', component: () => import('@/views/admin/KnowledgeTreeManagerView.vue') },
      { path: 'users', name: 'UserManager', component: () => import('@/views/admin/UserManagerView.vue') },
    ],
  },
  // Error pages
  {
    path: '/403',
    name: 'Forbidden',
    component: () => import('@/views/error/ForbiddenView.vue'),
    meta: { layout: 'blank' },
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/views/error/NotFoundView.vue'),
    meta: { layout: 'blank' },
  },
]
