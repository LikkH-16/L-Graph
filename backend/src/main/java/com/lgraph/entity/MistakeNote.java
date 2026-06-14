package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("lgraph_mistake_note")
public class MistakeNote {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long pageId;
    private String title;
    private String mistakeContent;
    private String correctSolution;
    private String tags;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
