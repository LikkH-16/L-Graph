package com.lgraph.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class GraphDataResponse {
    private List<GraphNodeDto> nodes;
    private List<GraphEdgeDto> edges;

    @Data
    @Builder
    public static class GraphNodeDto {
        private String id;
        private String label;
        private String type;
        private int size;
        private String color;
        private int masteryLevel;
        private Long knowledgeNodeId;
        private Long pageId;
    }

    @Data
    @Builder
    public static class GraphEdgeDto {
        private String id;
        private String source;
        private String target;
        private String type;
    }
}
