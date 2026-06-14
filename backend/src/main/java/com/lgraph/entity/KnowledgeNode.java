package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("lgraph_knowledge_node")
public class KnowledgeNode {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long subjectId;
    private String name;
    private String description;
    private Long parentId;
    private Integer level;
    private Integer orderIndex;
    private NodeType nodeType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
