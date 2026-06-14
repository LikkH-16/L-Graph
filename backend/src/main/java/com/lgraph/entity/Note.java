package com.lgraph.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("lgraph_note")
public class Note {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long subjectId;
    private String title;
    private String metadata;
    private NoteStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
