-- L-Graph Seed Data: CS 408 Knowledge Tree
SET NAMES utf8mb4;
USE lgraph;

-- Insert subjects
INSERT INTO lgraph_subject (name, description, icon, order_index) VALUES
('数据结构', '数据结构是计算机存储、组织数据的方式，研究数据的逻辑结构、物理结构及运算实现。', '🌲', 0),
('计算机组成原理', '研究计算机硬件系统的组成、工作原理和设计方法，涵盖运算器、控制器、存储器等核心部件。', '💻', 1),
('操作系统', '管理计算机硬件与软件资源的系统软件，提供进程管理、内存管理、文件系统和I/O管理功能。', '⚙️', 2),
('计算机网络', '研究计算机之间通信的原理、协议和网络架构，涵盖OSI模型及TCP/IP协议栈关键技术。', '🌐', 3);

-- Insert admin user (password: admin123)
INSERT INTO lgraph_user (username, password_hash, email, role) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'admin@lgraph.com', 'ADMIN'),
('student', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'student@lgraph.com', 'USER');

-- ===== Data Structures (subject_id = 1) =====
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '线性表', '线性表是n个数据元素的有限序列，是最基本、最简单、最常用的一种数据结构。', NULL, 1, 0, 'CHAPTER');

SET @ds_ch1 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '顺序存储', '用一组地址连续的存储单元依次存储线性表的数据元素，逻辑上相邻的元素物理上也相邻。', @ds_ch1, 2, 0, 'SECTION'),
(1, '链式存储', '通过指针将存储单元链接起来，逻辑上相邻的元素物理上不必相邻。', @ds_ch1, 2, 1, 'SECTION'),
(1, '应用', '线性表在实际编程中的常见应用场景。', @ds_ch1, 2, 2, 'SECTION');

SET @ds_ch2_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '链式存储' AND parent_id = @ds_ch1);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '单链表', '每个节点只有一个指针域指向后继节点的链表。', @ds_ch2_s2, 3, 0, 'TOPIC'),
(1, '双链表', '每个节点有两个指针域，分别指向前驱和后继节点的链表。', @ds_ch2_s2, 3, 1, 'TOPIC'),
(1, '循环链表', '最后一个节点的指针不是NULL，而是指向头节点的链表。', @ds_ch2_s2, 3, 2, 'TOPIC');

-- Chapter 2: Stack, Queue, Array
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '栈、队列和数组', '受限的线性结构，操作被限制在特定位置。', NULL, 1, 1, 'CHAPTER');

SET @ds_ch2 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '栈的基本概念与实现', '后进先出(LIFO)的线性表，仅在表尾进行插入和删除。', @ds_ch2, 2, 0, 'SECTION'),
(1, '队列的基本概念与实现', '先进先出(FIFO)的线性表，一端插入另一端删除。', @ds_ch2, 2, 1, 'SECTION'),
(1, '特殊矩阵的压缩存储', '对称矩阵、三角矩阵、稀疏矩阵的压缩方法。', @ds_ch2, 2, 2, 'SECTION');

-- Chapter 3: Trees
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '树与二叉树', '非线性层次结构，二叉树是最基本的树结构。', NULL, 1, 2, 'CHAPTER');

SET @ds_ch3 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '二叉树遍历', '按某种次序访问树中所有节点，每个节点仅访问一次。', @ds_ch3, 2, 0, 'SECTION'),
(1, '线索二叉树', '利用空指针域存储前驱后继信息，加速遍历。', @ds_ch3, 2, 1, 'SECTION'),
(1, '哈夫曼树与哈夫曼编码', '带权路径长度最短的二叉树，用于数据压缩。', @ds_ch3, 2, 2, 'SECTION');

SET @ds_ch3_s1 = (SELECT id FROM lgraph_knowledge_node WHERE name = '二叉树遍历' AND parent_id = @ds_ch3);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '前序遍历', '根→左→右 (NLR)', @ds_ch3_s1, 3, 0, 'TOPIC'),
(1, '中序遍历', '左→根→右 (LNR)，二叉排序树可得有序序列', @ds_ch3_s1, 3, 1, 'TOPIC'),
(1, '后序遍历', '左→右→根 (LRN)', @ds_ch3_s1, 3, 2, 'TOPIC'),
(1, '层次遍历', '按层依次访问，借助队列实现', @ds_ch3_s1, 3, 3, 'TOPIC');

-- Chapter 4: Graphs
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '图', '由顶点和边构成的非线性结构，表示多对多关系。', NULL, 1, 3, 'CHAPTER');

SET @ds_ch4 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '图的存储结构', '邻接矩阵和邻接表两种基本存储方式。', @ds_ch4, 2, 0, 'SECTION'),
(1, '图的遍历', '从某个顶点出发访问其余顶点，分为DFS和BFS。', @ds_ch4, 2, 1, 'SECTION'),
(1, '最小生成树', '连通网的所有生成树中，边权值之和最小的生成树。', @ds_ch4, 2, 2, 'SECTION'),
(1, '最短路径', '寻找图中两点之间权值和最小的路径。', @ds_ch4, 2, 3, 'SECTION');

SET @ds_ch4_s4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '最短路径' AND parent_id = @ds_ch4);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, 'Dijkstra算法', '单源最短路径，贪心策略，要求边权非负。', @ds_ch4_s4, 3, 0, 'TOPIC'),
(1, 'Floyd算法', '多源最短路径，动态规划，可处理负权边。', @ds_ch4_s4, 3, 1, 'TOPIC');

-- Chapter 5: Search
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '查找', '在数据集合中寻找满足条件的数据元素。', NULL, 1, 4, 'CHAPTER');

SET @ds_ch5 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '顺序查找与折半查找', '顺序查找O(n)，折半查找O(log n)要求有序。', @ds_ch5, 2, 0, 'SECTION'),
(1, 'B树与B+树', '多路平衡查找树，广泛应用于文件系统和数据库索引。', @ds_ch5, 2, 1, 'SECTION'),
(1, '散列表', '通过散列函数建立关键字与存储位置的映射关系。', @ds_ch5, 2, 2, 'SECTION'),
(1, 'KMP算法', '改进的字符串匹配算法，利用next数组避免回溯。', @ds_ch5, 2, 3, 'SECTION');

-- Chapter 6: Sort
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '排序', '将数据元素按关键字排成有序序列。', NULL, 1, 5, 'CHAPTER');

SET @ds_ch6 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(1, '插入排序', '每次将一个待排序记录插入到已排序序列中。', @ds_ch6, 2, 0, 'SECTION'),
(1, '交换排序', '两两比较，若逆序则交换。', @ds_ch6, 2, 1, 'SECTION'),
(1, '选择排序', '每趟选出最小(大)元素放到已排序序列末尾。', @ds_ch6, 2, 2, 'SECTION'),
(1, '归并排序', '将两个或多个有序表合并成一个有序表。', @ds_ch6, 2, 3, 'SECTION'),
(1, '基数排序', '按关键字各位进行多趟分配收集，不需要比较。', @ds_ch6, 2, 4, 'SECTION');

-- ===== Computer Organization (subject_id = 2) =====
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '计算机系统概述', '计算机硬件系统的基本组成和工作原理。', NULL, 1, 0, 'CHAPTER'),
(2, '数据的表示与运算', '数值数据在计算机中的表示方法和基本运算。', NULL, 1, 1, 'CHAPTER'),
(2, '存储器层次结构', '从高速缓存到外存的多级存储体系。', NULL, 1, 2, 'CHAPTER'),
(2, '指令系统', 'CPU能执行的指令集合，包括指令格式和寻址方式。', NULL, 1, 3, 'CHAPTER'),
(2, '中央处理器', 'CPU的数据通路、控制器设计和指令流水线技术。', NULL, 1, 4, 'CHAPTER'),
(2, '总线', '连接计算机各部件的公共通信干线。', NULL, 1, 5, 'CHAPTER'),
(2, '输入输出系统', 'CPU与外部设备进行数据交换的方法与接口。', NULL, 1, 6, 'CHAPTER');

-- ===== Operating Systems (subject_id = 3) =====
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '操作系统概述', '操作系统的定义、特征、功能和分类。', NULL, 1, 0, 'CHAPTER'),
(3, '进程管理', '进程/线程的概念、同步、死锁和处理机调度。', NULL, 1, 1, 'CHAPTER'),
(3, '内存管理', '内存分配、分页、分段和虚拟内存技术。', NULL, 1, 2, 'CHAPTER'),
(3, '文件管理', '文件系统结构、目录结构和存储空间管理。', NULL, 1, 3, 'CHAPTER'),
(3, 'I/O管理', 'I/O控制方式、SPOOLing技术和磁盘调度算法。', NULL, 1, 4, 'CHAPTER');

-- ===== Computer Networks (subject_id = 4) =====
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '计算机网络体系结构', 'OSI七层模型与TCP/IP四层模型。', NULL, 1, 0, 'CHAPTER'),
(4, '物理层', '数据传输的物理介质、信号编码和信道容量。', NULL, 1, 1, 'CHAPTER'),
(4, '数据链路层', '组帧、差错控制、流量控制和介质访问控制。', NULL, 1, 2, 'CHAPTER'),
(4, '网络层', 'IP地址、路由协议和拥塞控制。', NULL, 1, 3, 'CHAPTER'),
(4, '传输层', 'TCP/UDP协议、连接管理和可靠传输机制。', NULL, 1, 4, 'CHAPTER'),
(4, '应用层', 'DNS、HTTP、FTP、SMTP等应用层协议。', NULL, 1, 5, 'CHAPTER');
