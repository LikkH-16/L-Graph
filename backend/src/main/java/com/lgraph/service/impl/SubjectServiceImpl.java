package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.dto.response.SubjectTreeResponse;
import com.lgraph.entity.KnowledgeNode;
import com.lgraph.entity.PageKnowledgeNode;
import com.lgraph.entity.Subject;
import com.lgraph.mapper.KnowledgeNodeMapper;
import com.lgraph.mapper.PageKnowledgeNodeMapper;
import com.lgraph.mapper.SubjectMapper;
import com.lgraph.service.SubjectService;
import com.lgraph.util.TreeBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SubjectServiceImpl implements SubjectService {

    private final SubjectMapper subjectMapper;
    private final KnowledgeNodeMapper knowledgeNodeMapper;
    private final PageKnowledgeNodeMapper pknMapper;

    @Override
    public List<Subject> getAllSubjects() {
        return subjectMapper.selectList(null);
    }

    @Override
    public Subject getSubject(Long id) {
        return subjectMapper.selectById(id);
    }

    @Override
    public SubjectTreeResponse getKnowledgeTree(Long subjectId) {
        var nodes = knowledgeNodeMapper.selectList(
                new LambdaQueryWrapper<KnowledgeNode>().eq(KnowledgeNode::getSubjectId, subjectId));

        // Count pages per knowledge node — only for nodes in this subject
        var pageCounts = new HashMap<Long, Integer>();
        var masteryLevels = new HashMap<Long, Integer>();

        var nodeIds = nodes.stream().map(KnowledgeNode::getId).toList();
        if (!nodeIds.isEmpty()) {
            var pknList = pknMapper.selectList(
                    new LambdaQueryWrapper<PageKnowledgeNode>()
                            .in(PageKnowledgeNode::getKnowledgeNodeId, nodeIds));
            for (var pkn : pknList) {
                pageCounts.merge(pkn.getKnowledgeNodeId(), 1, Integer::sum);
            }
        }

        // For MVP, mastery defaults to 0 (we'd need user-review data for real values)
        for (var node : nodes) {
            masteryLevels.put(node.getId(), 0);
        }

        var tree = TreeBuilder.buildTree(nodes, pageCounts, masteryLevels);
        var nodeMap = TreeBuilder.buildNodeMap(nodes, pageCounts, masteryLevels);

        return SubjectTreeResponse.builder()
                .tree(tree)
                .nodes(nodeMap)
                .build();
    }
}
