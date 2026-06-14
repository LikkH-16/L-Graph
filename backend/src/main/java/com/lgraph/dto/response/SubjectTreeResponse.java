package com.lgraph.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class SubjectTreeResponse {
    private List<TreeNodeDto> tree;
    private Map<Long, KnowledgeNodeDto> nodes;
}
