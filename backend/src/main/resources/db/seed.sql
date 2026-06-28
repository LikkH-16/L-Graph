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
('admin', '$2a$10$ygDu4qeGp5iergREH25jseRYRb7EVCCSMkg/xx3xx7.Fu.BWwxX62', 'admin@lgraph.com', 'ADMIN'),
('student', '$2a$10$bkrhWpYPhIytPxxvElj6beLhD86.3URbP8uM829WnP2xMalPKSYIS', 'student@lgraph.com', 'USER');

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
-- Chapter 1: Overview
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '计算机系统概述', '计算机硬件系统的基本组成和工作原理。', NULL, 1, 0, 'CHAPTER');
SET @co_ch1 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '计算机发展历程', '从电子管到超大规模集成电路的发展简史。', @co_ch1, 2, 0, 'SECTION'),
(2, '冯·诺依曼结构', '存储程序概念，五大部件：运算器、控制器、存储器、输入、输出。', @co_ch1, 2, 1, 'SECTION'),
(2, '计算机性能指标', '主频、CPI、MIPS、FLOPS、吞吐量等性能度量。', @co_ch1, 2, 2, 'SECTION');

-- Chapter 2: Data Representation
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '数据的表示与运算', '数值数据在计算机中的表示方法和基本运算。', NULL, 1, 1, 'CHAPTER');
SET @co_ch2 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '进位计数制', '二进制、八进制、十进制、十六进制及其转换。', @co_ch2, 2, 0, 'SECTION'),
(2, '定点数表示', '原码、反码、补码、移码表示及相互转换。', @co_ch2, 2, 1, 'SECTION'),
(2, '浮点数表示', 'IEEE 754标准：符号、阶码、尾数，规格化与溢出。', @co_ch2, 2, 2, 'SECTION'),
(2, '算术逻辑单元', 'ALU结构，并行进位加法器，移位器设计。', @co_ch2, 2, 3, 'SECTION');

-- Chapter 3: Memory Hierarchy
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '存储器层次结构', '从高速缓存到外存的多级存储体系。', NULL, 1, 2, 'CHAPTER');
SET @co_ch3 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '主存储器', 'SRAM、DRAM工作原理，存储芯片扩展，字位扩展。', @co_ch3, 2, 0, 'SECTION'),
(2, 'Cache高速缓存', '局部性原理，地址映射（直接/组相联/全相联），替换算法，写策略。', @co_ch3, 2, 1, 'SECTION'),
(2, '虚拟存储器', '页式、段式、段页式管理，TLB快表，缺页中断。', @co_ch3, 2, 2, 'SECTION'),
(2, '辅助存储器', '磁盘结构、RAID、固态硬盘SSD。', @co_ch3, 2, 3, 'SECTION');

SET @co_ch3_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = 'Cache高速缓存' AND parent_id = @co_ch3);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '地址映射方式', '直接映射、全相联映射、组相联映射的硬件实现。', @co_ch3_s2, 3, 0, 'TOPIC'),
(2, '替换算法', 'LRU、FIFO、随机替换、LFU。', @co_ch3_s2, 3, 1, 'TOPIC'),
(2, '写策略', '写直达(write-through)、写回(write-back)、写分配。', @co_ch3_s2, 3, 2, 'TOPIC');

-- Chapter 4: Instruction Set
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '指令系统', 'CPU能执行的指令集合，包括指令格式和寻址方式。', NULL, 1, 3, 'CHAPTER');
SET @co_ch4 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '指令格式', '操作码OP、地址码A，定长/变长指令，扩展操作码。', @co_ch4, 2, 0, 'SECTION'),
(2, '寻址方式', '立即、直接、间接、寄存器、基址、变址、相对、堆栈寻址。', @co_ch4, 2, 1, 'SECTION'),
(2, 'CISC与RISC', '复杂/精简指令集的特点对比。', @co_ch4, 2, 2, 'SECTION');

-- Chapter 5: CPU
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '中央处理器', 'CPU的数据通路、控制器设计和指令流水线技术。', NULL, 1, 4, 'CHAPTER');
SET @co_ch5 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '数据通路', '单总线、双总线、三总线结构，数据传送路径。', @co_ch5, 2, 0, 'SECTION'),
(2, '控制器设计', '硬布线控制器与微程序控制器原理。', @co_ch5, 2, 1, 'SECTION'),
(2, '指令流水线', '五段流水(IF/ID/EX/MEM/WB)，流水线冒险与解决。', @co_ch5, 2, 2, 'SECTION');

SET @co_ch5_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '指令流水线' AND parent_id = @co_ch5);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '流水线性能计算', '吞吐率、加速比、效率公式。', @co_ch5_s3, 3, 0, 'TOPIC'),
(2, '结构冒险', '硬件资源冲突与解决方法。', @co_ch5_s3, 3, 1, 'TOPIC'),
(2, '数据冒险', 'RAW/WAR/WAW相关，旁路技术、流水线暂停。', @co_ch5_s3, 3, 2, 'TOPIC'),
(2, '控制冒险', '分支预测（静态/动态），延迟转移技术。', @co_ch5_s3, 3, 3, 'TOPIC');

-- Chapter 6: Bus
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '总线', '连接计算机各部件的公共通信干线。', NULL, 1, 5, 'CHAPTER');
SET @co_ch6 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '总线分类', '片内、系统、通信总线；地址/数据/控制总线。', @co_ch6, 2, 0, 'SECTION'),
(2, '总线仲裁', '集中式（链式查询、计数器定时、独立请求）与分布式仲裁。', @co_ch6, 2, 1, 'SECTION'),
(2, '总线标准', 'PCI、PCI Express、USB、SATA等标准。', @co_ch6, 2, 2, 'SECTION');

-- Chapter 7: I/O
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '输入输出系统', 'CPU与外部设备进行数据交换的方法与接口。', NULL, 1, 6, 'CHAPTER');
SET @co_ch7 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, 'I/O控制方式', '程序查询、程序中断、DMA、通道方式。', @co_ch7, 2, 0, 'SECTION'),
(2, '中断系统', '中断请求、判优、响应、服务、返回全过程。', @co_ch7, 2, 1, 'SECTION'),
(2, 'DMA方式', '直接存储器访问，DMA传送过程与控制器结构。', @co_ch7, 2, 2, 'SECTION');

-- ===== Operating Systems (subject_id = 3) =====
-- Chapter 1: Overview
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '操作系统概述', '操作系统的定义、特征、功能和分类。', NULL, 1, 0, 'CHAPTER');
SET @os_ch1 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '操作系统特征', '并发、共享、虚拟、异步四大特征。', @os_ch1, 2, 0, 'SECTION'),
(3, '操作系统分类', '批处理、分时、实时、网络、分布式、嵌入式。', @os_ch1, 2, 1, 'SECTION'),
(3, '运行环境', '内核态与用户态，中断/异常，系统调用。', @os_ch1, 2, 2, 'SECTION');

-- Chapter 2: Process Management
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '进程管理', '进程/线程的概念、同步、死锁和处理机调度。', NULL, 1, 1, 'CHAPTER');
SET @os_ch2 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '进程与线程', '进程状态转换、PCB、线程概念与多线程模型。', @os_ch2, 2, 0, 'SECTION'),
(3, '处理机调度', '调度的层次、时机、方式，调度算法。', @os_ch2, 2, 1, 'SECTION'),
(3, '进程同步', '临界区、PV操作、管程、经典同步问题。', @os_ch2, 2, 2, 'SECTION'),
(3, '死锁', '死锁条件、预防、避免（银行家算法）、检测与解除。', @os_ch2, 2, 3, 'SECTION');

SET @os_ch2_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '处理机调度' AND parent_id = @os_ch2);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '先来先服务FCFS', '按到达顺序调度，非抢占。', @os_ch2_s2, 3, 0, 'TOPIC'),
(3, '短作业优先SJF', '预估运行时间最短优先，可抢占(最短剩余时间)。', @os_ch2_s2, 3, 1, 'TOPIC'),
(3, '高响应比优先HRRN', '响应比=(等待+服务)/服务，折中FCFS与SJF。', @os_ch2_s2, 3, 2, 'TOPIC'),
(3, '时间片轮转RR', '每个进程分配固定时间片，轮转执行。', @os_ch2_s2, 3, 3, 'TOPIC'),
(3, '多级反馈队列', '多队列+动态优先级+时间片综合调度。', @os_ch2_s2, 3, 4, 'TOPIC');

SET @os_ch2_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '进程同步' AND parent_id = @os_ch2);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '信号量机制', 'P(wait)和V(signal)原语，整型/记录型信号量。', @os_ch2_s3, 3, 0, 'TOPIC'),
(3, '经典同步问题', '生产者-消费者、读者-写者、哲学家进餐。', @os_ch2_s3, 3, 1, 'TOPIC'),
(3, '管程(Monitor)', '高级同步原语，条件变量，信号量vs管程。', @os_ch2_s3, 3, 2, 'TOPIC');

-- Chapter 3: Memory Management
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '内存管理', '内存分配、分页、分段和虚拟内存技术。', NULL, 1, 2, 'CHAPTER');
SET @os_ch3 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '连续分配管理', '单一连续、固定分区、动态分区（首次/最佳/最坏适应）。', @os_ch3, 2, 0, 'SECTION'),
(3, '分页存储管理', '页表、快表TLB、多级页表、地址变换。', @os_ch3, 2, 1, 'SECTION'),
(3, '分段与段页式', '段表、段页式结合、地址变换过程。', @os_ch3, 2, 2, 'SECTION'),
(3, '虚拟内存', '局部性原理、请求分页、页面置换算法、抖动。', @os_ch3, 2, 3, 'SECTION');

SET @os_ch3_s4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '虚拟内存' AND parent_id = @os_ch3);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '页面置换算法', 'OPT、FIFO、LRU、CLOCK(最近未使用)、改进CLOCK。', @os_ch3_s4, 3, 0, 'TOPIC'),
(3, 'Belady异常', 'FIFO算法中分配页框增多反而缺页率升高的现象。', @os_ch3_s4, 3, 1, 'TOPIC'),
(3, '工作集模型', '防止抖动的工作集窗口与页面分配策略。', @os_ch3_s4, 3, 2, 'TOPIC');

-- Chapter 4: File Management
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '文件管理', '文件系统结构、目录结构和存储空间管理。', NULL, 1, 3, 'CHAPTER');
SET @os_ch4 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '文件概念', '文件逻辑结构（有结构/无结构），物理结构（连续/链式/索引）。', @os_ch4, 2, 0, 'SECTION'),
(3, '目录结构', '单级、两级、树形、无环图目录结构。', @os_ch4, 2, 1, 'SECTION'),
(3, '文件共享与保护', '硬链接/软链接(符号链接)，访问控制矩阵/列表。', @os_ch4, 2, 2, 'SECTION'),
(3, '空闲空间管理', '空闲表、空闲链表、位示图、成组链接法。', @os_ch4, 2, 3, 'SECTION');

-- Chapter 5: I/O Management
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, 'I/O管理', 'I/O控制方式、SPOOLing技术和磁盘调度算法。', NULL, 1, 4, 'CHAPTER');
SET @os_ch5 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, 'I/O控制方式', '程序I/O、中断驱动、DMA、I/O通道。', @os_ch5, 2, 0, 'SECTION'),
(3, 'SPOOLing技术', '假脱机技术，输入/输出井，守护进程。', @os_ch5, 2, 1, 'SECTION'),
(3, '磁盘调度算法', 'FCFS、SSTF、SCAN(电梯)、C-SCAN、LOOK算法。', @os_ch5, 2, 2, 'SECTION');

-- ===== Computer Networks (subject_id = 4) =====
-- Chapter 1: Architecture
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '计算机网络体系结构', 'OSI七层模型与TCP/IP四层模型。', NULL, 1, 0, 'CHAPTER');
SET @cn_ch1 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'OSI参考模型', '物理层→数据链路层→网络层→传输层→会话层→表示层→应用层。', @cn_ch1, 2, 0, 'SECTION'),
(4, 'TCP/IP模型', '网络接口层→网际层→传输层→应用层，与OSI的对比。', @cn_ch1, 2, 1, 'SECTION'),
(4, '网络性能指标', '速率、带宽、吞吐量、时延（发送/传播/处理/排队）、RTT。', @cn_ch1, 2, 2, 'SECTION');

-- Chapter 2: Physical Layer
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '物理层', '数据传输的物理介质、信号编码和信道容量。', NULL, 1, 1, 'CHAPTER');
SET @cn_ch2 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '通信基础', '模拟/数字信号，基带/宽带传输，码元、波特率、比特率。', @cn_ch2, 2, 0, 'SECTION'),
(4, '奈奎斯特定理与香农定理', '无噪声最大速率=2W·log₂V，有噪声最大速率=W·log₂(1+S/N)。', @cn_ch2, 2, 1, 'SECTION'),
(4, '编码与调制', 'NRZ、曼彻斯特、差分曼彻斯特编码，ASK/FSK/PSK调制。', @cn_ch2, 2, 2, 'SECTION'),
(4, '物理层设备', '中继器、集线器。', @cn_ch2, 2, 3, 'SECTION');

-- Chapter 3: Data Link Layer
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '数据链路层', '组帧、差错控制、流量控制和介质访问控制。', NULL, 1, 2, 'CHAPTER');
SET @cn_ch3 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '组帧方法', '字符计数、字符填充、零比特填充、违规编码。', @cn_ch3, 2, 0, 'SECTION'),
(4, '差错控制', '奇偶校验、CRC循环冗余校验、纠错（海明码）。', @cn_ch3, 2, 1, 'SECTION'),
(4, '流量与可靠传输', '停等协议、后退N帧(GBN)、选择重传(SR)。', @cn_ch3, 2, 2, 'SECTION'),
(4, '介质访问控制MAC', '信道划分（FDM/TDM/CDM）、随机访问、轮询访问。', @cn_ch3, 2, 3, 'SECTION');

SET @cn_ch3_s4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '介质访问控制MAC' AND parent_id = @cn_ch3);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'CSMA/CD协议', '载波监听多点接入/碰撞检测，以太网核心技术。', @cn_ch3_s4, 3, 0, 'TOPIC'),
(4, 'CSMA/CA协议', '碰撞避免，RTS/CTS握手，WiFi使用。', @cn_ch3_s4, 3, 1, 'TOPIC'),
(4, '以太网帧格式', 'MAC地址、类型字段、最小帧长与碰撞检测关系。', @cn_ch3_s4, 3, 2, 'TOPIC');

-- Chapter 4: Network Layer
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '网络层', 'IP地址、路由协议和拥塞控制。', NULL, 1, 3, 'CHAPTER');
SET @cn_ch4 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'IPv4地址', '分类编址、子网划分、CIDR无类域间路由、NAT。', @cn_ch4, 2, 0, 'SECTION'),
(4, 'IPv6', '128位地址空间、简化首部、扩展首部、双栈/隧道过渡。', @cn_ch4, 2, 1, 'SECTION'),
(4, '路由协议', 'RIP(距离向量)、OSPF(链路状态)、BGP(路径向量)。', @cn_ch4, 2, 2, 'SECTION'),
(4, 'ARP与ICMP', '地址解析协议ARP，网际控制报文协议ICMP（ping/traceroute）。', @cn_ch4, 2, 3, 'SECTION');

SET @cn_ch4_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '路由协议' AND parent_id = @cn_ch4);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'RIP协议', '基于UDP，跳数度量(max=15)，30s交换，慢收敛问题。', @cn_ch4_s3, 3, 0, 'TOPIC'),
(4, 'OSPF协议', '基于IP，SPF算法(Dijkstra)，快速收敛，分区域。', @cn_ch4_s3, 3, 1, 'TOPIC'),
(4, 'BGP协议', '路径向量，AS间路由，基于TCP，策略控制。', @cn_ch4_s3, 3, 2, 'TOPIC');

-- Chapter 5: Transport Layer
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '传输层', 'TCP/UDP协议、连接管理和可靠传输机制。', NULL, 1, 4, 'CHAPTER');
SET @cn_ch5 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'UDP协议', '无连接、不可靠、面向报文、8字节首部、校验和。', @cn_ch5, 2, 0, 'SECTION'),
(4, 'TCP协议', '面向连接、可靠、全双工、字节流、流量控制、拥塞控制。', @cn_ch5, 2, 1, 'SECTION');

SET @cn_ch5_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = 'TCP协议' AND parent_id = @cn_ch5);
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '三次握手与四次挥手', '建立连接(SYN-SYN+ACK-ACK)，释放连接(FIN-ACK-FIN-ACK)。', @cn_ch5_s2, 3, 0, 'TOPIC'),
(4, '流量控制', '滑动窗口，rwnd接收窗口，零窗口探测。', @cn_ch5_s2, 3, 1, 'TOPIC'),
(4, '拥塞控制', '慢开始、拥塞避免、快重传、快恢复（Tahoe/Reno）。', @cn_ch5_s2, 3, 2, 'TOPIC');

-- Chapter 6: Application Layer
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '应用层', 'DNS、HTTP、FTP、SMTP等应用层协议。', NULL, 1, 5, 'CHAPTER');
SET @cn_ch6 = LAST_INSERT_ID();
INSERT INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'DNS域名系统', '层次域名、域名服务器（根/顶级/权威/本地）、递归/迭代查询。', @cn_ch6, 2, 0, 'SECTION'),
(4, 'HTTP协议', '请求/响应报文、状态码、Cookie、HTTPS(TLS)。', @cn_ch6, 2, 1, 'SECTION'),
(4, '电子邮件协议', 'SMTP(发送)、POP3/IMAP(接收)、MIME格式。', @cn_ch6, 2, 2, 'SECTION'),
(4, 'FTP文件传输', '控制连接(TCP21)+数据连接(TCP20被动/主动模式)。', @cn_ch6, 2, 3, 'SECTION');
