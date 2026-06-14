package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("lgraph_page_knowledge_node")
public class PageKnowledgeNode {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long pageId;
    private Long knowledgeNodeId;
    private LocalDateTime createdAt;
}
