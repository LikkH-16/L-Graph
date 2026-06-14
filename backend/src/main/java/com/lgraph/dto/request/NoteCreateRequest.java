package com.lgraph.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class NoteCreateRequest {
    @NotNull(message = "学科ID不能为空")
    private Long subjectId;
    @NotBlank(message = "标题不能为空")
    private String title;
}
