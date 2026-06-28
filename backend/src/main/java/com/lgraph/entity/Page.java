package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@TableName("lgraph_page")
public class Page {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long noteId;
    private String title;
    private String content;
    private Integer orderIndex;
    private Integer reviewRound;
    private Integer masteryLevel;
    private LocalDateTime lastReviewedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /** 关联的知识节点 ID 列表（非数据库字段，由 Service 层填充） */
    @TableField(exist = false)
    private List<Long> attachedNodeIds;
}
