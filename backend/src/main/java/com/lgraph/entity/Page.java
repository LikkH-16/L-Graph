package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

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
}
