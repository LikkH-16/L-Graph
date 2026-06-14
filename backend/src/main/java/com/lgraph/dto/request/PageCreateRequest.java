package com.lgraph.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class PageCreateRequest {
    @NotNull(message = "笔记ID不能为空")
    private Long noteId;
    @NotBlank(message = "标题不能为空")
    private String title;
    private String content;
}
