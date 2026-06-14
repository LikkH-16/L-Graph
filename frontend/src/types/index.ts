// ===== API Response =====
export interface ApiResponse<T> {
  code: number
  message: string
  data: T
  timestamp: number
}

export interface PageResult<T> {
  records: T[]
  total: number
  size: number
  current: number
}

// ===== Auth =====
export interface User {
  id: number
  username: string
  email: string
  role: 'USER' | 'ADMIN'
  avatarUrl: string | null
  createdAt: string
}

export interface LoginCredentials {
  username: string
  password: string
}

export interface RegisterData {
  username: string
  email: string
  password: string
}

export interface LoginResponse {
  token: string
  user: User
}

// ===== Subject =====
export interface Subject {
  id: number
  name: string
  description: string
  icon: string
  parentId: number | null
  orderIndex: number
  children: Subject[]
  knowledgeNodeCount: number
  pageCount: number
}

// ===== Knowledge Node =====
export type NodeType = 'CHAPTER' | 'SECTION' | 'TOPIC'

export interface KnowledgeNode {
  id: number
  subjectId: number
  name: string
  description: string
  parentId: number | null
  level: number
  orderIndex: number
  nodeType: NodeType
  children: KnowledgeNode[]
  masteryLevel: 0 | 1 | 2 | 3
  pageCount: number
  reviewCount: number
}

export interface KnowledgeNodeTreeItem {
  id: number
  name: string
  nodeType: NodeType
  level: number
  masteryLevel: number
  pageCount: number
  children: KnowledgeNodeTreeItem[]
}

// ===== Note =====
export type NoteStatus = 'DRAFT' | 'PUBLISHED'

export interface Note {
  id: number
  userId: number
  subjectId: number
  title: string
  status: NoteStatus
  createdAt: string
  updatedAt: string
}

// ===== Page =====
export interface Page {
  id: number
  noteId: number
  title: string
  content: string
  orderIndex: number
  attachedNodeIds: number[]
  reviewRound: number
  masteryLevel: 0 | 1 | 2 | 3
  lastReviewedAt: string | null
  createdAt: string
  updatedAt: string
}

export interface PageCreateRequest {
  noteId: number
  title: string
  content?: string
}

export interface PageUpdateRequest {
  title?: string
  content?: string
  orderIndex?: number
}

export interface PageAttachRequest {
  nodeIds: number[]
}

// ===== Graph =====
export interface GraphNode {
  id: string
  label: string
  type: 'knowledge' | 'page'
  size: number
  color: string
  masteryLevel: 0 | 1 | 2 | 3
  knowledgeNodeId?: number
  pageId?: number
  subjectId?: number
  reviewRound?: number
  x?: number
  y?: number
  properties: Record<string, unknown>
}

export interface GraphEdge {
  id: string
  source: string
  target: string
  type: 'PARENT_OF' | 'ATTACHED_TO' | 'REFERENCES'
  label?: string
}

export interface GraphData {
  nodes: GraphNode[]
  edges: GraphEdge[]
}

// ===== Review =====
export interface ReviewRecord {
  id: number
  userId: number
  pageId: number
  reviewRound: number
  masteryLevel: number
  timeSpentSeconds: number
  notes: string
  reviewedAt: string
}

export interface ReviewProgress {
  pageId: number
  reviewRound: number
  masteryLevel: number
  reviewCount: number
  lastReviewedAt: string | null
}

export interface SubjectStats {
  subjectId: number
  totalPages: number
  totalKnowledgeNodes: number
  pagesReviewed: number
  round1Count: number
  round2Count: number
  round3Count: number
  masteredCount: number
  completionPercent: number
}

// ===== Recommendation =====
export interface Recommendation {
  id: number
  type: 'SIBLING' | 'MISTAKE' | 'PREREQUISITE'
  knowledgeNodeId: number
  knowledgeNodeName: string
  pageId?: number
  pageTitle?: string
  reason: string
}

// ===== Admin =====
export interface AdminStats {
  userCount: number
  subjectCount: number
  knowledgeNodeCount: number
  noteCount: number
  pageCount: number
  reviewCount: number
}
