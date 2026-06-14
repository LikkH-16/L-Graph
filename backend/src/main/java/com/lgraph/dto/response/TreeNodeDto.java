package com.lgraph.dto.response;

import com.lgraph.entity.KnowledgeNode;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class TreeNodeDto {
    private Long id;
    private String name;
    private String nodeType;
    private Integer level;
    private Integer masteryLevel;
    private Integer pageCount;
    private List<TreeNodeDto> children = new ArrayList<>();

    public static TreeNodeDto from(KnowledgeNode node, int masteryLevel, int pageCount) {
        var dto = new TreeNodeDto();
        dto.setId(node.getId());
        dto.setName(node.getName());
        dto.setNodeType(node.getNodeType().name());
        dto.setLevel(node.getLevel());
        dto.setMasteryLevel(masteryLevel);
        dto.setPageCount(pageCount);
        return dto;
    }
}
