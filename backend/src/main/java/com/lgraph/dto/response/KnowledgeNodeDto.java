package com.lgraph.dto.response;

import com.lgraph.entity.KnowledgeNode;
import lombok.Data;

@Data
public class KnowledgeNodeDto {
    private Long id;
    private Long subjectId;
    private String name;
    private String description;
    private Long parentId;
    private Integer level;
    private String nodeType;
    private Integer masteryLevel;
    private Integer pageCount;

    public static KnowledgeNodeDto from(KnowledgeNode node, int masteryLevel, int pageCount) {
        var dto = new KnowledgeNodeDto();
        dto.setId(node.getId());
        dto.setSubjectId(node.getSubjectId());
        dto.setName(node.getName());
        dto.setDescription(node.getDescription());
        dto.setParentId(node.getParentId());
        dto.setLevel(node.getLevel());
        dto.setNodeType(node.getNodeType().name());
        dto.setMasteryLevel(masteryLevel);
        dto.setPageCount(pageCount);
        return dto;
    }
}
