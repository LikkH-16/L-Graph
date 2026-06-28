package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.dto.response.GraphDataResponse;
import com.lgraph.dto.response.GraphDataResponse.GraphEdgeDto;
import com.lgraph.dto.response.GraphDataResponse.GraphNodeDto;
import com.lgraph.entity.KnowledgeNode;
import com.lgraph.entity.PageKnowledgeNode;
import com.lgraph.entity.ReviewRecord;
import com.lgraph.mapper.KnowledgeNodeMapper;
import com.lgraph.mapper.PageKnowledgeNodeMapper;
import com.lgraph.mapper.ReviewRecordMapper;
import com.lgraph.service.GraphService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class GraphServiceImpl implements GraphService {

    private final KnowledgeNodeMapper knMapper;
    private final PageKnowledgeNodeMapper pknMapper;
    private final ReviewRecordMapper reviewRecordMapper;

    private static final String[] MASTERY_COLORS = {"#6366f1", "#f43f5e", "#f59e0b", "#10b981"};

    @Override
    public GraphDataResponse getSubjectGraph(Long subjectId) {
        return buildGraph(subjectId, null);
    }

    @Override
    public GraphDataResponse getUserGraph(Long subjectId, Long userId) {
        return buildGraph(subjectId, userId);
    }

    private GraphDataResponse buildGraph(Long subjectId, Long userId) {
        var allNodes = knMapper.selectList(
                new LambdaQueryWrapper<KnowledgeNode>().eq(KnowledgeNode::getSubjectId, subjectId));

        // Collect IDs of all knowledge nodes in this subject
        var nodeIds = allNodes.stream().map(KnowledgeNode::getId).toList();

        // Count pages per knowledge node — only for nodes in this subject
        Map<Long, Integer> pageCounts = new HashMap<>();
        if (!nodeIds.isEmpty()) {
            var pknList = pknMapper.selectList(
                    new LambdaQueryWrapper<PageKnowledgeNode>()
                            .in(PageKnowledgeNode::getKnowledgeNodeId, nodeIds));
            for (var pkn : pknList) {
                pageCounts.merge(pkn.getKnowledgeNodeId(), 1, Integer::sum);
            }
        }

        // Compute per-knowledge-node mastery from user's review records (when userId is provided)
        Map<Long, Integer> nodeMastery = new HashMap<>();
        if (userId != null && !nodeIds.isEmpty()) {
            // Find pages attached to these knowledge nodes
            var pknList = pknMapper.selectList(
                    new LambdaQueryWrapper<PageKnowledgeNode>()
                            .in(PageKnowledgeNode::getKnowledgeNodeId, nodeIds));
            var pageIdToNodeIds = new HashMap<Long, List<Long>>();
            var attachedPageIds = new HashSet<Long>();
            for (var pkn : pknList) {
                pageIdToNodeIds.computeIfAbsent(pkn.getPageId(), k -> new ArrayList<>())
                        .add(pkn.getKnowledgeNodeId());
                attachedPageIds.add(pkn.getPageId());
            }

            if (!attachedPageIds.isEmpty()) {
                // Get review records for this user on those pages
                var reviews = reviewRecordMapper.selectList(
                        new LambdaQueryWrapper<ReviewRecord>()
                                .eq(ReviewRecord::getUserId, userId)
                                .in(ReviewRecord::getPageId, attachedPageIds));

                // Group reviews by page, take max mastery per page
                var pageMaxMastery = new HashMap<Long, Integer>();
                for (var r : reviews) {
                    pageMaxMastery.merge(r.getPageId(), r.getMasteryLevel(), Math::max);
                }

                // Propagate page mastery to attached knowledge nodes (take max across pages)
                for (var entry : pageMaxMastery.entrySet()) {
                    Long pageId = entry.getKey();
                    int mastery = entry.getValue();
                    var nodeIdsForPage = pageIdToNodeIds.get(pageId);
                    if (nodeIdsForPage != null) {
                        for (Long nodeId : nodeIdsForPage) {
                            nodeMastery.merge(nodeId, mastery, Math::max);
                        }
                    }
                }
            }
        }

        // Build graph nodes
        var graphNodes = new ArrayList<GraphNodeDto>();
        for (var kn : allNodes) {
            int pages = pageCounts.getOrDefault(kn.getId(), 0);
            int mastery = nodeMastery.getOrDefault(kn.getId(), 0);
            graphNodes.add(GraphNodeDto.builder()
                    .id("kn-" + kn.getId())
                    .label(kn.getName())
                    .type("knowledge")
                    .size(30 + pages * 8)
                    .color(MASTERY_COLORS[Math.min(mastery, 3)])
                    .masteryLevel(mastery)
                    .knowledgeNodeId(kn.getId())
                    .build());
        }

        // Build edges (parent-of)
        var graphEdges = new ArrayList<GraphEdgeDto>();
        for (var kn : allNodes) {
            if (kn.getParentId() != null) {
                graphEdges.add(GraphEdgeDto.builder()
                        .id("e-parent-" + kn.getParentId() + "-" + kn.getId())
                        .source("kn-" + kn.getParentId())
                        .target("kn-" + kn.getId())
                        .type("PARENT_OF")
                        .build());
            }
        }

        // Sibling references
        var byParent = new HashMap<Long, List<Long>>();
        for (var kn : allNodes) {
            if (kn.getParentId() != null) {
                byParent.computeIfAbsent(kn.getParentId(), k -> new ArrayList<>()).add(kn.getId());
            }
        }
        for (var siblings : byParent.values()) {
            for (int i = 0; i < siblings.size(); i++) {
                for (int j = i + 1; j < siblings.size(); j++) {
                    graphEdges.add(GraphEdgeDto.builder()
                            .id("e-sib-" + siblings.get(i) + "-" + siblings.get(j))
                            .source("kn-" + siblings.get(i))
                            .target("kn-" + siblings.get(j))
                            .type("REFERENCES")
                            .build());
                }
            }
        }

        return GraphDataResponse.builder()
                .nodes(graphNodes)
                .edges(graphEdges)
                .build();
    }
}
