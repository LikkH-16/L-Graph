package com.lgraph.dto.request;

import lombok.Data;

@Data
public class PageUpdateRequest {
    private String title;
    private String content;
    private Integer orderIndex;
}
