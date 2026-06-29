# L-Graph 软件设计规格说明书 (SDS)

**文档编号**：LG-SDS-001
**项目名称**：L-Graph 知识图谱笔记平台
**版本**：V1.0
**日期**：2026-06-29

---

## 文档变更历史记录

| 序号 | 变更日期 | 变更人员 | 变更内容详情描述 | 版本 |
|------|----------|----------|------------------|------|
| 1 | 2026-06-29 | - | 初始版本 | V1.0 |

---

## 目录

1. 引言
2. 软件设计约束
3. 软件设计
   - 3.1 软件体系结构设计
   - 3.2 用户界面设计
   - 3.3 用例设计
   - 3.4 类设计
   - 3.5 数据库设计
   - 3.6 界面导航设计

---

## 1. 引言

### 1.1 编写目的

本文档详细描述 L-Graph 知识图谱笔记平台的设计方案，涵盖软件体系结构、模块划分、类设计、数据库设计和界面设计。作为从需求到编码的桥梁，为开发人员提供明确的实现依据。

### 1.2 读者对象

- **开发人员**：根据设计文档进行编码实现
- **架构师**：审查设计方案的合理性
- **测试人员**：理解模块间的交互关系，设计集成测试
- **项目管理者**：评估开发工作量

### 1.3 软件项目概述

L-Graph 是一个面向计算机考研备考的知识图谱笔记平台。核心概念：
- **学科 (Subject)** → **知识节点 (KnowledgeNode)** → **笔记 (Note)** → **笔记页 (Page)**
- 用户编写 Markdown 笔记页，关联到知识树节点，通过复习机制追踪掌握程度
- 图谱可视化展示知识点层级与学习进度

**技术栈**：Vue 3 + Spring Boot 3.2 + MySQL 8.0 + AntV G6 + Reveal.js

### 1.4 文档概述

| 章节 | 内容 |
|------|------|
| 第 2 章 | 设计目标和约束 |
| 第 3.1 节 | 体系结构（分层架构、模块划分） |
| 第 3.2 节 | 用户界面设计（布局、组件树） |
| 第 3.3 节 | 用例设计（核心用例的类协作） |
| 第 3.4 节 | 类设计（服务层、实体层、DTO 层） |
| 第 3.5 节 | 数据库设计（ER 图、表结构） |
| 第 3.6 节 | 界面导航设计（路由、页面跳转） |

### 1.5 定义

| 术语 | 说明 |
|------|------|
| Vditor | 浏览器端 Markdown 编辑器，支持所见即所得(IR)模式 |
| G6 | AntV 图可视化引擎，用于知识图谱渲染 |
| Pinia | Vue 3 状态管理库 |
| MyBatis-Plus | MyBatis 增强工具，提供 Lambda 查询和自动 CRUD |
| Reveal.js | HTML 幻灯片框架，用于演示模式 |
| JWT | JSON Web Token，无状态身份认证 |
| B/S 架构 | 浏览器-服务器架构 |
| SPA | 单页应用 (Single Page Application) |

### 1.6 参考资料

| 名称 | 版本/来源 |
|------|-----------|
| L-Graph SRS | docs/SRS.md |
| Spring Boot Reference | 3.2.5 |
| Vue 3 Guide | vuejs.org |
| AntV G6 v5 文档 | g6.antv.antgroup.com |
| Element Plus 文档 | element-plus.org |

---

## 2. 软件设计约束

### 2.1 软件设计目标和原则

| 原则 | 应用 |
|------|------|
| **前后端分离** | Vue 3 SPA + Spring Boot REST API，通过 JSON 通信 |
| **无状态认证** | JWT Bearer Token，服务端不存储会话 |
| **分层架构** | Controller → Service → Mapper → DB，清晰的职责分离 |
| **组件化** | 前端使用 Vue SFC 单文件组件，Pinia 管理全局状态 |
| **RESTful API** | 资源导向的 URL 设计，统一 ApiResponse 响应格式 |
| **ORM 抽象** | MyBatis-Plus LambdaQueryWrapper，类型安全的查询 |

### 2.2 软件设计的约束和限制

| 约束 | 说明 |
|------|------|
| 数据库 | MySQL 8.0，InnoDB 引擎，utf8mb4 字符集 |
| 后端语言 | Java 21，Spring Boot 3.2.5 |
| 前端语言 | TypeScript，Vue 3 Composition API |
| 构建工具 | Maven (后端)，Vite (前端) |
| 部署 | Docker Compose 容器编排 |
| 缓存 | Redis（已配置，当前版本未深度使用） |
| 图数据库 | Neo4j（已配置，当前版本未深度使用，图谱基于 MySQL） |
| 认证 | Spring Security + JWT (jjwt 0.12.5) |
| 密码存储 | BCrypt 加密 |
| 日志 | MyBatis-Plus StdOutImpl (开发环境) |

---

## 3. 软件设计

### 3.1 软件体系结构设计

#### 3.1.1 分层架构

```
┌─────────────────────────────────────────────────┐
│                 表示层 (Presentation)              │
│         Vue 3 + Element Plus + G6 + Reveal       │
│   ┌──────────┬──────────┬──────────────────┐    │
│   │  视图组件  │  Pinia   │  composables     │    │
│   │  (Views)  │ (Stores) │  (业务逻辑复用)   │    │
│   └──────────┴──────────┴──────────────────┘    │
├─────────────────────────────────────────────────┤
│                API 通信层 (HTTP/JSON)              │
│            Axios + JWT Interceptor               │
├─────────────────────────────────────────────────┤
│                 服务层 (Service)                   │
│         Spring Boot REST Controllers             │
│   ┌──────────────────────────────────────┐      │
│   │   AuthController  │  GraphController │      │
│   │   NoteController  │  PageController  │      │
│   │   ReviewController│  SubjectController│     │
│   └──────────┬───────────────────────────┘      │
│              ▼                                   │
│   ┌──────────────────────────────────────┐      │
│   │        Service 接口 + 实现类           │      │
│   │   AuthService │ GraphService │ ...    │      │
│   └──────────┬───────────────────────────┘      │
├─────────────────────────────────────────────────┤
│               持久层 (Persistence)                │
│         MyBatis-Plus + MySQL 8.0                 │
│   ┌──────────────────────────────────────┐      │
│   │  UserMapper  │  PageMapper  │  ...   │      │
│   └──────────────────────────────────────┘      │
├─────────────────────────────────────────────────┤
│               基础设施层 (Infrastructure)          │
│         Docker Compose (MySQL + Neo4j + Redis)   │
└─────────────────────────────────────────────────┘
```

#### 3.1.2 后端模块划分

| 模块 | 包路径 | 职责 |
|------|--------|------|
| 认证模块 | `security/` | JWT 生成/校验、Spring Security 配置、过滤器 |
| 用户模块 | `service/AuthService` | 注册、登录、获取当前用户 |
| 学科模块 | `service/impl/SubjectServiceImpl` | 学科列表查询 |
| 知识节点模块 | `service/impl/KnowledgeNodeServiceImpl` | 知识树 CRUD |
| 笔记模块 | `service/impl/NoteServiceImpl` | 笔记和页面管理 |
| 图谱模块 | `service/impl/GraphServiceImpl` | 图谱数据构建（节点+边+mastery） |
| 复习模块 | `service/impl/ReviewServiceImpl` | 复习记录、进度统计 |
| 异常模块 | `exception/` | 全局异常处理、BusinessException |

#### 3.1.3 前端模块划分

| 模块 | 路径 | 职责 |
|------|------|------|
| 视图 | `views/` | 登录、注册、学科列表、学科详情、图谱、进度、演示 |
| 布局 | `components/layout/` | MainLayout、AppSidebar、AppNavbar |
| 状态管理 | `stores/` | authStore、subjectStore、noteStore、pageStore、graphStore、reviewStore、treeStore、uiStore |
| API 层 | `api/` | authApi、subjectApi、noteApi、pageApi、graphApi、reviewApi、knowledgeNodeApi |
| 可复用逻辑 | `composables/` | useGraph、useMarkdown、useSlide、useAccountStorage |
| 路由 | `router/` | 路由配置 + 导航守卫 |

### 3.2 用户界面设计

#### 3.2.1 整体布局

```
┌──────────────────────────────────────────────────┐
│  App.vue (布局分发)                                │
│  ┌──────────┬────────────────────┬─────────────┐ │
│  │          │   AppNavbar        │              │ │
│  │          │ [面包屑] [编辑/图谱/│              │ │
│  │AppSidebar│  演示/进度] [工具栏]│  RightPanel  │ │
│  │          ├────────────────────┤ (可收拢)     │ │
│  │ 学科下拉  │                    │              │ │
│  │ 知识树    │   <router-view>    │  关联推荐    │ │
│  │          │   内容区域          │              │ │
│  │ +添加节点 │                    │              │ │
│  │          ├────────────────────┤              │ │
│  │          │  StatusBar [页数|状态]              │ │
│  └──────────┴────────────────────┴─────────────┘ │
└──────────────────────────────────────────────────┘
```

#### 3.2.2 核心页面组件树

```
App.vue
├── AuthLayout (meta.layout='auth')
│   ├── LoginView
│   │   └── account-panel (已保存账号下拉)
│   └── RegisterView
├── MainLayout (meta.layout='main')
│   ├── AppSidebar
│   │   ├── el-select (学科下拉)
│   │   ├── el-input (搜索)
│   │   ├── KnowledgeTree ← el-tree
│   │   ├── 添加节点按钮 + Dialog
│   │   └── 用户菜单
│   ├── AppNavbar
│   │   ├── el-breadcrumb
│   │   └── view-tabs (编辑/图谱/演示/进度)
│   ├── <router-view>
│   │   ├── SubjectListView (学科卡片网格)
│   │   ├── SubjectDetailView
│   │   │   ├── subject-hero
│   │   │   ├── filter-banner (知识点筛选提示)
│   │   │   ├── page-tabs-bar (页面标签)
│   │   │   ├── MarkdownEditor → Vditor
│   │   │   └── context-menu (右键菜单)
│   │   ├── GraphExplorerView
│   │   │   ├── graph-header (+ 返回按钮)
│   │   │   ├── KnowledgeGraph → G6
│   │   │   │   ├── GraphControls
│   │   │   │   └── GraphLegend
│   │   │   └── el-drawer (节点详情)
│   │   ├── ReviewProgressView
│   │   │   ├── stats-grid (统计卡片)
│   │   │   ├── round-breakdown (轮次分布)
│   │   │   └── page-row (页面列表+复习按钮)
│   │   └── PageEditorView
│   └── RightPanel
└── BlankLayout (meta.layout='blank')
    ├── SlideShowView → SlideRenderer → Reveal.js
    ├── ForbiddenView (403)
    └── NotFoundView (404)
```

### 3.3 用例设计

#### 用例 UC-01：用户注册的设计

**参与类**：`RegisterView` → `AuthController` → `AuthServiceImpl` → `UserMapper` + `PasswordEncoder` + `JwtTokenProvider`

**协作流程**：
1. `RegisterView.onSubmit()` 前端表单校验
2. `authStore.register(form)` 调用 `POST /auth/register`
3. `AuthController.register()` 接收 `RegisterRequest`，`@Valid` 校验
4. `AuthServiceImpl.register()`：查重用户名/邮箱 → BCrypt 编码密码 → `user.setRole(USER)` → `userMapper.insert(user)` → 生成 JWT
5. 返回 `LoginResponse(token, UserDto)`，前端 `localStorage.setItem('token')`
6. `router.push('/subjects')` 跳转

#### 用例 UC-02：用户登录的设计

**参与类**：`LoginView` → `AuthController` → `AuthServiceImpl` → `JwtTokenProvider` + `JwtAuthenticationFilter`

**协作流程**：
1. `LoginView` 支持账号保存/密码记忆（`useAccountStorage` localStorage）
2. `POST /auth/login` 验证密码（BCrypt.matches）
3. JWT 生成含 `sub=userId`, `role=USER/ADMIN`, `exp=24h`
4. 前端存储 token 到 localStorage，axios interceptor 自动携带 `Authorization: Bearer`
5. 后续请求经 `JwtAuthenticationFilter` 提取 token → 验证 → 构建 `UsernamePasswordAuthenticationToken` → 存入 `SecurityContext`
6. `SecurityConfig` 根据 `hasRole("ADMIN")` 保护 `/admin/**`

#### 用例 UC-03：编辑笔记页的设计

**参与类**：`SubjectDetailView` → `MarkdownEditor` → `useMarkdown` → `Vditor` → `PageStore`

**协作流程**：
1. `onMounted` 加载 `noteStore.fetchNote(subjectId)` → 获取页面列表
2. 用户选择知识节点（侧栏 `KnowledgeTree.onNodeClick`）→ 筛选 `displayPages`
3. 用户点击页面 Tab → `pageStore.fetchPage(id)` → 加载内容到 Vditor
4. Vditor IR 模式实时编辑，`input` 回调更新 `content` ref
5. `MarkdownEditor` emit `update:modelValue` → `onContentChange` → `pageStore.content = value` + `pageStore.markDirty()`
6. 用户点击保存 → `pageStore.savePage(pageId)` → `PUT /pages/{id}` → `isDirty = false`
7. 自动保存：30s 定时器检查 `isDirty` 并自动调用 `savePage()`

#### 用例 UC-04：知识图谱的设计

**参与类**：`GraphExplorerView` → `GraphStore` → `KnowledgeGraph` → `useGraph` → G6

**协作流程**：
1. `graphStore.fetchGraphData(subjectId)` → `GET /graph/subject/{subjectId}/user` (个性化接口)
2. `GraphServiceImpl.buildGraph(subjectId, userId)`：
   - 查 `lgraph_knowledge_node` 全部节点 → 构建 GraphNode
   - 查 `lgraph_page_knowledge_node` 统计每节点页面数
   - 若 `userId != null`，查 `lgraph_review_record` 计算每节点 mastery
   - 构建边：PARENT_OF（父子）+ REFERENCES（同级引用）
3. 前端 G6 dagre 布局渲染，节点颜色 = masteryColor[masteryLevel]
4. `watchEffect` → `initGraph(container, data)`

#### 用例 UC-05：复习操作的设计

**参与类**：`ReviewProgressView` → `ReviewStore` → `ReviewController`

**协作流程**：
1. `reviewStore.fetchProgress(subjectId)` → `GET /reviews/subject/{id}` → 统计总页数/完成度/轮次
2. 用户点击"复习" → `markReview(page)` → `recordReview(pageId, round+1, mastery+1)` → `POST /reviews`
3. `ReviewServiceImpl.recordReview()` → 插入 `lgraph_review_record` + 更新 `lgraph_page.mastery_level`
4. 下次查看图谱时，`getUserGraph` 读取 `ReviewRecord` 计算 mastery → 节点颜色更新

### 3.4 类设计

#### 3.4.1 实体层 (Entity)

```
┌────────────┐     ┌──────────────┐     ┌─────────────────┐
│   User     │     │   Subject    │     │  KnowledgeNode  │
├────────────┤     ├──────────────┤     ├─────────────────┤
│ - id       │     │ - id         │     │ - id            │
│ - username │     │ - name       │     │ - subjectId     │
│ - password │     │ - description│     │ - name          │
│ - email    │     │ - icon       │     │ - description   │
│ - role     │     │ - parentId   │     │ - parentId      │
│ - avatarUrl│     │ - orderIndex │     │ - level         │
│ - deleted  │     └──────────────┘     │ - nodeType      │
└────────────┘                          │   (CHAPTER/     │
      │                                 │   SECTION/TOPIC)│
      │                                 └────────┬────────┘
      ▼                                          │
┌────────────┐                          ┌────────▼────────┐
│    Note    │                          │ PageKnowledgeNode│
├────────────┤                          │ (关联表 M:N)      │
│ - id       │                          │ - pageId         │
│ - userId   │                          │ - knowledgeNodeId│
│ - subjectId│                          └─────────────────┘
│ - title    │
│ - status   │
└─────┬──────┘
      │
      ▼
┌────────────┐     ┌──────────────────┐
│    Page    │     │  ReviewRecord    │
├────────────┤     ├──────────────────┤
│ - id       │     │ - id             │
│ - noteId   │     │ - userId         │
│ - title    │     │ - pageId         │
│ - content  │     │ - reviewRound    │
│ - orderIdx │     │ - masteryLevel   │
│ - reviewRd │     │ - timeSpent      │
│ - masteryLv│     │ - notes          │
└────────────┘     └──────────────────┘
```

#### 3.4.2 安全组件层

```
┌───────────────────┐    ┌─────────────────────┐
│ SecurityConfig    │───>│JwtAuthenticationFilter│
│ + filterChain()   │    │ + doFilterInternal() │
│ + passwordEncoder │    │ - extractToken()     │
└───────────────────┘    └──────────┬──────────┘
                                    │
                          ┌─────────▼──────────┐
                          │  JwtTokenProvider   │
                          │ + generateToken()   │
                          │ + validateToken()   │
                          │ + parseToken()      │
                          └─────────────────────┘
```

#### 3.4.3 前端状态管理层 (Pinia Stores)

```
┌───────────────┐  ┌────────────────┐  ┌─────────────────┐
│  authStore    │  │  subjectStore  │  │ knowledgeTreeStore│
├───────────────┤  ├────────────────┤  ├─────────────────┤
│ user, token   │  │ subjects[]     │  │ treeData[]      │
│ isAuthenticated│ │ currentSubject │  │ selectedNodeId  │
│ isAdmin       │  │ loading        │  │ expandedKeys[]  │
│ login/register│  │ fetchSubjects  │  │ fetchTree/select │
│ logout        │  │ setCurrent     │  │ createNode      │
└───────────────┘  └────────────────┘  └─────────────────┘

┌───────────────┐  ┌────────────────┐  ┌─────────────────┐
│  noteStore    │  │   pageStore    │  │  reviewStore    │
├───────────────┤  ├────────────────┤  ├─────────────────┤
│ pages[]       │  │ content        │  │ subjectStats    │
│ currentNote   │  │ isDirty,saving │  │ reviews[]       │
│ loading       │  │ attachedNodes  │  │ fetchProgress   │
│ fetchNote     │  │ fetchPage      │  │ recordReview    │
│ createPage    │  │ savePage       │  └─────────────────┘
└───────────────┘  │ attachToNode   │
                   └────────────────┘

┌───────────────┐  ┌────────────────┐
│  graphStore   │  │    uiStore     │
├───────────────┤  ├────────────────┤
│ nodes[],edges[]│ │ sidebarCollapsed│
│ selectedNode  │  │ theme          │
│ loading       │  │ viewMode       │
│ fetchGraphData│  │ toggleSidebar  │
└───────────────┘  └────────────────┘
```

### 3.5 数据库设计

#### 3.5.1 ER 图

```
┌────────┐     ┌──────────┐     ┌──────────────┐
│  User  │1───*│   Note   │1───*│     Page     │*───*┐
└────────┘     └────┬─────┘     └──────┬───────┘     │
                    │ subjectId        │              │
                    ▼                  │ attachedNodes│
              ┌──────────┐            │ (M:N)        │
              │ Subject  │            ▼              │
              └────┬─────┘   ┌──────────────────┐    │
                   │1        │PageKnowledgeNode │    │
                   ▼         │ (关联表)           │    │
           ┌──────────────┐  │ pageId + nodeId  │    │
           │KnowledgeNode │  └────────┬─────────┘    │
           │ (自引用树)     │*         │              │
           │ parentId → id │          │              │
           └──────────────┘           ▼              │
                                   ┌──────────────┐  │
┌────────┐                         │KnowledgeNode │◄─┘
│  User  │1───* ┌──────────────┐   │ (知识节点)    │
└────────┘      │ ReviewRecord │   └──────────────┘
                │ userId+pageId│
                │ reviewRound  │
                │ masteryLevel │
                └──────────────┘
```

#### 3.5.2 核心表结构

**lgraph_user** (用户表)
| 字段 | 类型 | 约束 | 说明 |
|------|------|------|------|
| id | BIGINT | PK AUTO | 主键 |
| username | VARCHAR(50) | UNIQUE NOT NULL | 用户名 |
| password_hash | VARCHAR(255) | NOT NULL | BCrypt 密码 |
| email | VARCHAR(100) | UNIQUE NOT NULL | 邮箱 |
| role | ENUM('USER','ADMIN') | DEFAULT 'USER' | 角色 |
| deleted | TINYINT | DEFAULT 0 | 逻辑删除 |
| created_at | DATETIME | DEFAULT NOW | 创建时间 |

**lgraph_knowledge_node** (知识节点表)
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | 主键 |
| subject_id | BIGINT FK | 所属学科 |
| name | VARCHAR(200) | 节点名称 |
| parent_id | BIGINT FK(SELF) | 父节点(自引用) |
| level | INT | 层级(1章/2节/3主题) |
| node_type | ENUM('CHAPTER','SECTION','TOPIC') | 节点类型 |

**lgraph_page** (笔记页表)
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT PK | 主键 |
| note_id | BIGINT FK | 所属笔记 |
| title | VARCHAR(200) | 页面标题 |
| content | LONGTEXT | Markdown 内容 |
| review_round | INT DEFAULT 0 | 复习轮次 |
| mastery_level | INT DEFAULT 0 | 掌握等级(0-3) |

**lgraph_page_knowledge_node** (页面-节点关联表 M:N)
| 字段 | 类型 | 说明 |
|------|------|------|
| page_id | BIGINT FK | 页面 |
| knowledge_node_id | BIGINT FK | 知识节点 |
| UNIQUE(page_id, knowledge_node_id) | | 唯一约束 |

**lgraph_review_record** (复习记录表)
| 字段 | 类型 | 说明 |
|------|------|------|
| user_id | BIGINT FK | 用户 |
| page_id | BIGINT FK | 页面 |
| review_round | INT | 复习轮次 |
| mastery_level | INT | 掌握等级 |
| time_spent_seconds | INT | 学习时长 |
| reviewed_at | DATETIME | 复习时间 |

### 3.6 界面导航设计

#### 3.6.1 路由表

| 路径 | 组件 | 布局 | 权限 |
|------|------|------|------|
| `/` | → `/subjects` | - | - |
| `/login` | LoginView | auth | guest |
| `/register` | RegisterView | auth | guest |
| `/subjects` | SubjectListView | main | requiresAuth |
| `/subjects/:subjectId` | SubjectDetailView | main | requiresAuth |
| `/subjects/:subjectId/graph` | GraphExplorerView | main | requiresAuth |
| `/review/:subjectId` | ReviewProgressView | main | requiresAuth |
| `/subjects/:subjectId/slides` | SlideShowView | blank | requiresAuth |
| `/admin` | AdminLayout | - | requiresAdmin |
| `/403` | ForbiddenView | blank | - |
| `/*` | NotFoundView | blank | - |

#### 3.6.2 导航守卫逻辑

```
router.beforeEach(to, from, next):
  1. requiresAuth && !isAuthenticated → 重定向 /login?redirect=原路径
  2. guest && isAuthenticated → 重定向 /subjects
  3. requiresAdmin && !isAdmin → 重定向 /403
  4. 其余 → 放行
```

#### 3.6.3 主要页面跳转流程

```
登录成功 → /subjects (学科列表)
点击学科卡片 → /subjects/:id (学科详情+编辑器)
点击"图谱"标签 → /subjects/:id/graph
点击"进度"标签 → /review/:id
点击"演示"标签 → /subjects/:id/slides (全屏)
面包屑 HomeFilled → /subjects (列表，侧栏重置)
管理员图标 → /admin (仅 ADMIN)
侧栏知识节点点击 → /subjects/:id (选中节点+筛选页面)
```

---

## 附录：完整文件结构

```
Learning-Graph/
├── docker-compose.yml
├── backend/
│   ├── pom.xml
│   └── src/main/
│       ├── java/com/lgraph/
│       │   ├── config/SecurityConfig.java
│       │   ├── controller/
│       │   │   ├── AuthController.java
│       │   │   ├── NoteController.java
│       │   │   ├── PageController.java
│       │   │   ├── GraphController.java
│       │   │   └── ReviewController.java
│       │   ├── dto/
│       │   │   ├── request/ (LoginRequest, RegisterRequest, ...)
│       │   │   └── response/ (ApiResponse, LoginResponse, GraphDataResponse, ...)
│       │   ├── entity/ (User, Note, Page, KnowledgeNode, ReviewRecord, ...)
│       │   ├── exception/ (BusinessException, GlobalExceptionHandler)
│       │   ├── mapper/ (UserMapper, PageMapper, ...)
│       │   ├── security/ (JwtTokenProvider, JwtAuthenticationFilter, ...)
│       │   └── service/impl/ (AuthServiceImpl, GraphServiceImpl, ...)
│       └── resources/
│           ├── application.yml
│           └── db/ (schema.sql, seed.sql)
├── frontend/
│   ├── package.json
│   ├── vite.config.ts
│   └── src/
│       ├── api/ (auth.api.ts, graph.api.ts, ...)
│       ├── components/
│       │   ├── layout/ (MainLayout, AppSidebar, AppNavbar)
│       │   ├── graph/ (KnowledgeGraph, GraphControls, GraphLegend)
│       │   ├── editor/ (MarkdownEditor)
│       │   └── slide/ (SlideRenderer, SlideControls)
│       ├── composables/ (useGraph, useMarkdown, useSlide, useAccountStorage)
│       ├── router/ (routes.ts, guards.ts)
│       ├── stores/ (auth, subject, note, page, graph, review, tree, ui)
│       ├── views/ (auth/, subjects/, graph/, review/, slide/, note/, admin/)
│       └── types/index.ts
└── docs/
    ├── SRS.md
    ├── SDS.md
    └── auth-diagrams.puml
```
