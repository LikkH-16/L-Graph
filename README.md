# L-Graph: Learning Graph

智能导航式知识图谱笔记平台 —— 基于预置学科体系的 Markdown 笔记系统

## 项目架构

```
Learning-Graph/
├── frontend/           # Vue 3 + TypeScript (Vite)
│   ├── src/
│   │   ├── api/        # HTTP 客户端与 API 模块 (含 Mock 数据)
│   │   ├── assets/     # SCSS 样式、主题、字体
│   │   ├── components/ # 可复用组件 (编辑器、图谱、知识树、幻灯片)
│   │   ├── composables/ # Vue 3 组合式函数
│   │   ├── router/     # 路由配置与守卫
│   │   ├── stores/     # Pinia 状态管理
│   │   ├── types/      # TypeScript 类型定义
│   │   └── views/      # 页面视图
│   └── ...
├── backend/            # Spring Boot 3.2 + MyBatis-Plus
│   ├── src/main/java/com/lgraph/
│   │   ├── config/     # Spring 配置 (Security, CORS, MyBatis-Plus, Neo4j)
│   │   ├── security/   # JWT 认证过滤器与 Token 提供器
│   │   ├── controller/ # REST 控制器
│   │   ├── service/    # 业务逻辑层
│   │   ├── mapper/     # MyBatis-Plus 映射器
│   │   ├── entity/     # 数据库实体
│   │   ├── dto/        # 数据传输对象
│   │   └── exception/  # 全局异常处理
│   └── src/main/resources/
│       └── db/         # SQL Schema 与种子数据
└── docker-compose.yml  # MySQL + Neo4j + Redis
```

## 技术栈

| 层级 | 技术 |
|------|------|
| **前端框架** | Vue 3 + TypeScript |
| **UI 库** | Element Plus |
| **可视化引擎** | AntV G6 (知识图谱) |
| **编辑器** | Vditor (Markdown + LaTeX + 代码高亮) |
| **演示** | Reveal.js |
| **后端框架** | Spring Boot 3.2 |
| **认证** | Spring Security + JWT |
| **持久层** | MyBatis-Plus |
| **数据库** | MySQL 8.0 + Neo4j 5 |
| **缓存** | Redis 7 |

## 快速启动

### 1. 启动基础设施

```bash
docker-compose up -d
```

### 2. 启动后端

```bash
cd backend
./mvnw spring-boot:run
```

后端运行在 `http://localhost:8080/api/v1`

### 3. 启动前端

```bash
cd frontend
npm install
npm run dev
```

前端运行在 `http://localhost:3000`

## 演示账号

| 角色 | 用户名 | 说明 |
|------|--------|------|
| 管理员 | `admin` | 可管理知识树和用户 |
| 学生 | `student` | 普通用户，编写笔记 |

## 核心功能

- **学科知识字典预载**: CS 408 考研四门学科完整知识树
- **层级化笔记管理**: Markdown 编辑，LaTeX 数学公式，代码高亮
- **动态知识图谱**: 知识点关系可视化，节点颜色反映掌握程度
- **智能关联推荐**: 兄弟知识点推荐，错题关联
- **沉浸式复习演示**: 一键将笔记渲染为交互式幻灯片
- **学习进度追踪**: 复习轮次可视化，完成度统计
