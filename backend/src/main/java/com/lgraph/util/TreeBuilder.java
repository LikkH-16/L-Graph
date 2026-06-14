package com.lgraph.util;

import com.lgraph.dto.response.KnowledgeNodeDto;
import com.lgraph.dto.response.TreeNodeDto;
import com.lgraph.entity.KnowledgeNode;

import java.util.*;
import java.util.stream.Collectors;

public class TreeBuilder {

    public static List<TreeNodeDto> buildTree(List<KnowledgeNode> nodes,
                                               Map<Long, Integer> pageCounts,
                                               Map<Long, Integer> masteryLevels) {
        Map<Long, TreeNodeDto> dtoMap = new HashMap<>();
        List<TreeNodeDto> roots = new ArrayList<>();

        for (var node : nodes) {
            int pages = pageCounts.getOrDefault(node.getId(), 0);
            int mastery = masteryLevels.getOrDefault(node.getId(), 0);
            var dto = TreeNodeDto.from(node, mastery, pages);
            dtoMap.put(node.getId(), dto);
        }

        for (var node : nodes) {
            var dto = dtoMap.get(node.getId());
            if (node.getParentId() == null || !dtoMap.containsKey(node.getParentId())) {
                roots.add(dto);
            } else {
                dtoMap.get(node.getParentId()).getChildren().add(dto);
            }
        }

        return roots;
    }

    public static Map<Long, KnowledgeNodeDto> buildNodeMap(List<KnowledgeNode> nodes,
                                                            Map<Long, Integer> pageCounts,
                                                            Map<Long, Integer> masteryLevels) {
        return nodes.stream().collect(Collectors.toMap(
                KnowledgeNode::getId,
                n -> KnowledgeNodeDto.from(n,
                        masteryLevels.getOrDefault(n.getId(), 0),
                        pageCounts.getOrDefault(n.getId(), 0))
        ));
    }
}
