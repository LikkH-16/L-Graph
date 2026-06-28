-- L-Graph Seed Data Upgrade: Adds detailed subsections for 计组/OS/计网
-- Run this manually if the database already has data:
--   docker exec -i lgraph-mysql mysql -uroot -proot lgraph < backend/src/main/resources/db/migrate_knowledge_v2.sql
SET NAMES utf8mb4;
USE lgraph;

-- ===== Computer Organization (subject_id = 2) =====
-- Chapter 1: Overview
SET @co_ch1 = (SELECT id FROM lgraph_knowledge_node WHERE name = '计算机系统概述' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '计算机发展历程', '从电子管到超大规模集成电路的发展简史。', @co_ch1, 2, 0, 'SECTION'),
(2, '冯·诺依曼结构', '存储程序概念，五大部件：运算器、控制器、存储器、输入、输出。', @co_ch1, 2, 1, 'SECTION'),
(2, '计算机性能指标', '主频、CPI、MIPS、FLOPS、吞吐量等性能度量。', @co_ch1, 2, 2, 'SECTION');

-- Chapter 2: Data Representation
SET @co_ch2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '数据的表示与运算' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '进位计数制', '二进制、八进制、十进制、十六进制及其转换。', @co_ch2, 2, 0, 'SECTION'),
(2, '定点数表示', '原码、反码、补码、移码表示及相互转换。', @co_ch2, 2, 1, 'SECTION'),
(2, '浮点数表示', 'IEEE 754标准：符号、阶码、尾数，规格化与溢出。', @co_ch2, 2, 2, 'SECTION'),
(2, '算术逻辑单元', 'ALU结构，并行进位加法器，移位器设计。', @co_ch2, 2, 3, 'SECTION');

-- Chapter 3: Memory
SET @co_ch3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '存储器层次结构' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '主存储器', 'SRAM、DRAM工作原理，存储芯片扩展，字位扩展。', @co_ch3, 2, 0, 'SECTION'),
(2, 'Cache高速缓存', '局部性原理，地址映射（直接/组相联/全相联），替换算法，写策略。', @co_ch3, 2, 1, 'SECTION'),
(2, '虚拟存储器', '页式、段式、段页式管理，TLB快表，缺页中断。', @co_ch3, 2, 2, 'SECTION'),
(2, '辅助存储器', '磁盘结构、RAID、固态硬盘SSD。', @co_ch3, 2, 3, 'SECTION');

SET @co_ch3_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = 'Cache高速缓存' AND parent_id = @co_ch3 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '地址映射方式', '直接映射、全相联映射、组相联映射的硬件实现。', @co_ch3_s2, 3, 0, 'TOPIC'),
(2, '替换算法', 'LRU、FIFO、随机替换、LFU。', @co_ch3_s2, 3, 1, 'TOPIC'),
(2, '写策略', '写直达(write-through)、写回(write-back)、写分配。', @co_ch3_s2, 3, 2, 'TOPIC');

-- Chapter 4: Instruction Set
SET @co_ch4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '指令系统' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '指令格式', '操作码OP、地址码A，定长/变长指令，扩展操作码。', @co_ch4, 2, 0, 'SECTION'),
(2, '寻址方式', '立即、直接、间接、寄存器、基址、变址、相对、堆栈寻址。', @co_ch4, 2, 1, 'SECTION'),
(2, 'CISC与RISC', '复杂/精简指令集的特点对比。', @co_ch4, 2, 2, 'SECTION');

-- Chapter 5: CPU
SET @co_ch5 = (SELECT id FROM lgraph_knowledge_node WHERE name = '中央处理器' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '数据通路', '单总线、双总线、三总线结构，数据传送路径。', @co_ch5, 2, 0, 'SECTION'),
(2, '控制器设计', '硬布线控制器与微程序控制器原理。', @co_ch5, 2, 1, 'SECTION'),
(2, '指令流水线', '五段流水(IF/ID/EX/MEM/WB)，流水线冒险与解决。', @co_ch5, 2, 2, 'SECTION');

SET @co_ch5_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '指令流水线' AND parent_id = @co_ch5 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '流水线性能计算', '吞吐率、加速比、效率公式。', @co_ch5_s3, 3, 0, 'TOPIC'),
(2, '结构冒险', '硬件资源冲突与解决方法。', @co_ch5_s3, 3, 1, 'TOPIC'),
(2, '数据冒险', 'RAW/WAR/WAW相关，旁路技术、流水线暂停。', @co_ch5_s3, 3, 2, 'TOPIC'),
(2, '控制冒险', '分支预测（静态/动态），延迟转移技术。', @co_ch5_s3, 3, 3, 'TOPIC');

-- Chapter 6: Bus
SET @co_ch6 = (SELECT id FROM lgraph_knowledge_node WHERE name = '总线' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, '总线分类', '片内、系统、通信总线；地址/数据/控制总线。', @co_ch6, 2, 0, 'SECTION'),
(2, '总线仲裁', '集中式（链式查询、计数器定时、独立请求）与分布式仲裁。', @co_ch6, 2, 1, 'SECTION'),
(2, '总线标准', 'PCI、PCI Express、USB、SATA等标准。', @co_ch6, 2, 2, 'SECTION');

-- Chapter 7: I/O
SET @co_ch7 = (SELECT id FROM lgraph_knowledge_node WHERE name = '输入输出系统' AND subject_id = 2 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(2, 'I/O控制方式', '程序查询、程序中断、DMA、通道方式。', @co_ch7, 2, 0, 'SECTION'),
(2, '中断系统', '中断请求、判优、响应、服务、返回全过程。', @co_ch7, 2, 1, 'SECTION'),
(2, 'DMA方式', '直接存储器访问，DMA传送过程与控制器结构。', @co_ch7, 2, 2, 'SECTION');

-- ===== Operating Systems (subject_id = 3) =====
-- Chapter 1: Overview
SET @os_ch1 = (SELECT id FROM lgraph_knowledge_node WHERE name = '操作系统概述' AND subject_id = 3 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '操作系统特征', '并发、共享、虚拟、异步四大特征。', @os_ch1, 2, 0, 'SECTION'),
(3, '操作系统分类', '批处理、分时、实时、网络、分布式、嵌入式。', @os_ch1, 2, 1, 'SECTION'),
(3, '运行环境', '内核态与用户态，中断/异常，系统调用。', @os_ch1, 2, 2, 'SECTION');

-- Chapter 2: Process Management
SET @os_ch2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '进程管理' AND subject_id = 3 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '进程与线程', '进程状态转换、PCB、线程概念与多线程模型。', @os_ch2, 2, 0, 'SECTION'),
(3, '处理机调度', '调度的层次、时机、方式，调度算法。', @os_ch2, 2, 1, 'SECTION'),
(3, '进程同步', '临界区、PV操作、管程、经典同步问题。', @os_ch2, 2, 2, 'SECTION'),
(3, '死锁', '死锁条件、预防、避免（银行家算法）、检测与解除。', @os_ch2, 2, 3, 'SECTION');

SET @os_ch2_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '处理机调度' AND parent_id = @os_ch2 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '先来先服务FCFS', '按到达顺序调度，非抢占。', @os_ch2_s2, 3, 0, 'TOPIC'),
(3, '短作业优先SJF', '预估运行时间最短优先，可抢占(最短剩余时间)。', @os_ch2_s2, 3, 1, 'TOPIC'),
(3, '高响应比优先HRRN', '响应比=(等待+服务)/服务，折中FCFS与SJF。', @os_ch2_s2, 3, 2, 'TOPIC'),
(3, '时间片轮转RR', '每个进程分配固定时间片，轮转执行。', @os_ch2_s2, 3, 3, 'TOPIC'),
(3, '多级反馈队列', '多队列+动态优先级+时间片综合调度。', @os_ch2_s2, 3, 4, 'TOPIC');

SET @os_ch2_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '进程同步' AND parent_id = @os_ch2 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '信号量机制', 'P(wait)和V(signal)原语，整型/记录型信号量。', @os_ch2_s3, 3, 0, 'TOPIC'),
(3, '经典同步问题', '生产者-消费者、读者-写者、哲学家进餐。', @os_ch2_s3, 3, 1, 'TOPIC'),
(3, '管程(Monitor)', '高级同步原语，条件变量，信号量vs管程。', @os_ch2_s3, 3, 2, 'TOPIC');

-- Chapter 3: Memory
SET @os_ch3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '内存管理' AND subject_id = 3 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '连续分配管理', '单一连续、固定分区、动态分区（首次/最佳/最坏适应）。', @os_ch3, 2, 0, 'SECTION'),
(3, '分页存储管理', '页表、快表TLB、多级页表、地址变换。', @os_ch3, 2, 1, 'SECTION'),
(3, '分段与段页式', '段表、段页式结合、地址变换过程。', @os_ch3, 2, 2, 'SECTION'),
(3, '虚拟内存', '局部性原理、请求分页、页面置换算法、抖动。', @os_ch3, 2, 3, 'SECTION');

SET @os_ch3_s4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '虚拟内存' AND parent_id = @os_ch3 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '页面置换算法', 'OPT、FIFO、LRU、CLOCK(最近未使用)、改进CLOCK。', @os_ch3_s4, 3, 0, 'TOPIC'),
(3, 'Belady异常', 'FIFO算法中分配页框增多反而缺页率升高的现象。', @os_ch3_s4, 3, 1, 'TOPIC'),
(3, '工作集模型', '防止抖动的工作集窗口与页面分配策略。', @os_ch3_s4, 3, 2, 'TOPIC');

-- Chapter 4: File
SET @os_ch4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '文件管理' AND subject_id = 3 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, '文件概念', '文件逻辑结构（有结构/无结构），物理结构（连续/链式/索引）。', @os_ch4, 2, 0, 'SECTION'),
(3, '目录结构', '单级、两级、树形、无环图目录结构。', @os_ch4, 2, 1, 'SECTION'),
(3, '文件共享与保护', '硬链接/软链接(符号链接)，访问控制矩阵/列表。', @os_ch4, 2, 2, 'SECTION'),
(3, '空闲空间管理', '空闲表、空闲链表、位示图、成组链接法。', @os_ch4, 2, 3, 'SECTION');

-- Chapter 5: I/O
SET @os_ch5 = (SELECT id FROM lgraph_knowledge_node WHERE name = 'I/O管理' AND subject_id = 3 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(3, 'I/O控制方式', '程序I/O、中断驱动、DMA、I/O通道。', @os_ch5, 2, 0, 'SECTION'),
(3, 'SPOOLing技术', '假脱机技术，输入/输出井，守护进程。', @os_ch5, 2, 1, 'SECTION'),
(3, '磁盘调度算法', 'FCFS、SSTF、SCAN(电梯)、C-SCAN、LOOK算法。', @os_ch5, 2, 2, 'SECTION');

-- ===== Computer Networks (subject_id = 4) =====
-- Chapter 1: Architecture
SET @cn_ch1 = (SELECT id FROM lgraph_knowledge_node WHERE name = '计算机网络体系结构' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'OSI参考模型', '物理层→数据链路层→网络层→传输层→会话层→表示层→应用层。', @cn_ch1, 2, 0, 'SECTION'),
(4, 'TCP/IP模型', '网络接口层→网际层→传输层→应用层，与OSI的对比。', @cn_ch1, 2, 1, 'SECTION'),
(4, '网络性能指标', '速率、带宽、吞吐量、时延（发送/传播/处理/排队）、RTT。', @cn_ch1, 2, 2, 'SECTION');

-- Chapter 2: Physical
SET @cn_ch2 = (SELECT id FROM lgraph_knowledge_node WHERE name = '物理层' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '通信基础', '模拟/数字信号，基带/宽带传输，码元、波特率、比特率。', @cn_ch2, 2, 0, 'SECTION'),
(4, '奈奎斯特定理与香农定理', '无噪声最大速率=2W·log₂V，有噪声最大速率=W·log₂(1+S/N)。', @cn_ch2, 2, 1, 'SECTION'),
(4, '编码与调制', 'NRZ、曼彻斯特、差分曼彻斯特编码，ASK/FSK/PSK调制。', @cn_ch2, 2, 2, 'SECTION'),
(4, '物理层设备', '中继器、集线器。', @cn_ch2, 2, 3, 'SECTION');

-- Chapter 3: Data Link
SET @cn_ch3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '数据链路层' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '组帧方法', '字符计数、字符填充、零比特填充、违规编码。', @cn_ch3, 2, 0, 'SECTION'),
(4, '差错控制', '奇偶校验、CRC循环冗余校验、纠错（海明码）。', @cn_ch3, 2, 1, 'SECTION'),
(4, '流量与可靠传输', '停等协议、后退N帧(GBN)、选择重传(SR)。', @cn_ch3, 2, 2, 'SECTION'),
(4, '介质访问控制MAC', '信道划分（FDM/TDM/CDM）、随机访问、轮询访问。', @cn_ch3, 2, 3, 'SECTION');

SET @cn_ch3_s4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '介质访问控制MAC' AND parent_id = @cn_ch3 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'CSMA/CD协议', '载波监听多点接入/碰撞检测，以太网核心技术。', @cn_ch3_s4, 3, 0, 'TOPIC'),
(4, 'CSMA/CA协议', '碰撞避免，RTS/CTS握手，WiFi使用。', @cn_ch3_s4, 3, 1, 'TOPIC'),
(4, '以太网帧格式', 'MAC地址、类型字段、最小帧长与碰撞检测关系。', @cn_ch3_s4, 3, 2, 'TOPIC');

-- Chapter 4: Network
SET @cn_ch4 = (SELECT id FROM lgraph_knowledge_node WHERE name = '网络层' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'IPv4地址', '分类编址、子网划分、CIDR无类域间路由、NAT。', @cn_ch4, 2, 0, 'SECTION'),
(4, 'IPv6', '128位地址空间、简化首部、扩展首部、双栈/隧道过渡。', @cn_ch4, 2, 1, 'SECTION'),
(4, '路由协议', 'RIP(距离向量)、OSPF(链路状态)、BGP(路径向量)。', @cn_ch4, 2, 2, 'SECTION'),
(4, 'ARP与ICMP', '地址解析协议ARP，网际控制报文协议ICMP（ping/traceroute）。', @cn_ch4, 2, 3, 'SECTION');

SET @cn_ch4_s3 = (SELECT id FROM lgraph_knowledge_node WHERE name = '路由协议' AND parent_id = @cn_ch4 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'RIP协议', '基于UDP，跳数度量(max=15)，30s交换，慢收敛问题。', @cn_ch4_s3, 3, 0, 'TOPIC'),
(4, 'OSPF协议', '基于IP，SPF算法(Dijkstra)，快速收敛，分区域。', @cn_ch4_s3, 3, 1, 'TOPIC'),
(4, 'BGP协议', '路径向量，AS间路由，基于TCP，策略控制。', @cn_ch4_s3, 3, 2, 'TOPIC');

-- Chapter 5: Transport
SET @cn_ch5 = (SELECT id FROM lgraph_knowledge_node WHERE name = '传输层' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'UDP协议', '无连接、不可靠、面向报文、8字节首部、校验和。', @cn_ch5, 2, 0, 'SECTION'),
(4, 'TCP协议', '面向连接、可靠、全双工、字节流、流量控制、拥塞控制。', @cn_ch5, 2, 1, 'SECTION');

SET @cn_ch5_s2 = (SELECT id FROM lgraph_knowledge_node WHERE name = 'TCP协议' AND parent_id = @cn_ch5 LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, '三次握手与四次挥手', '建立连接(SYN-SYN+ACK-ACK)，释放连接(FIN-ACK-FIN-ACK)。', @cn_ch5_s2, 3, 0, 'TOPIC'),
(4, '流量控制', '滑动窗口，rwnd接收窗口，零窗口探测。', @cn_ch5_s2, 3, 1, 'TOPIC'),
(4, '拥塞控制', '慢开始、拥塞避免、快重传、快恢复（Tahoe/Reno）。', @cn_ch5_s2, 3, 2, 'TOPIC');

-- Chapter 6: Application
SET @cn_ch6 = (SELECT id FROM lgraph_knowledge_node WHERE name = '应用层' AND subject_id = 4 AND parent_id IS NULL LIMIT 1);
INSERT IGNORE INTO lgraph_knowledge_node (subject_id, name, description, parent_id, level, order_index, node_type) VALUES
(4, 'DNS域名系统', '层次域名、域名服务器（根/顶级/权威/本地）、递归/迭代查询。', @cn_ch6, 2, 0, 'SECTION'),
(4, 'HTTP协议', '请求/响应报文、状态码、Cookie、HTTPS(TLS)。', @cn_ch6, 2, 1, 'SECTION'),
(4, '电子邮件协议', 'SMTP(发送)、POP3/IMAP(接收)、MIME格式。', @cn_ch6, 2, 2, 'SECTION'),
(4, 'FTP文件传输', '控制连接(TCP21)+数据连接(TCP20被动/主动模式)。', @cn_ch6, 2, 3, 'SECTION');
