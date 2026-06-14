package com.lgraph.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ReviewRequest {
    @NotNull(message = "页面ID不能为空")
    private Long pageId;
    @Min(1) @Max(3)
    private int reviewRound;
    @Min(0) @Max(5)
    private int masteryLevel;
    private int timeSpentSeconds;
    private String notes;
}
