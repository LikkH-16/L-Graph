package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("lgraph_review_record")
public class ReviewRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long pageId;
    private Integer reviewRound;
    private Integer masteryLevel;
    private Integer timeSpentSeconds;
    private String notes;
    private LocalDateTime reviewedAt;
}
