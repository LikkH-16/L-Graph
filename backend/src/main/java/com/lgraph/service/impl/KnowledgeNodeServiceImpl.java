package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.entity.KnowledgeNode;
import com.lgraph.mapper.KnowledgeNodeMapper;
import com.lgraph.service.KnowledgeNodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class KnowledgeNodeServiceImpl implements KnowledgeNodeService {

    private final KnowledgeNodeMapper mapper;

    @Override
    public KnowledgeNode getNode(Long id) {
        return mapper.selectById(id);
    }

    @Override
    public List<KnowledgeNode> getChildren(Long id) {
        return mapper.selectList(
                new LambdaQueryWrapper<KnowledgeNode>().eq(KnowledgeNode::getParentId, id));
    }

    @Override
    public List<KnowledgeNode> getSiblings(Long id) {
        var node = mapper.selectById(id);
        if (node == null || node.getParentId() == null) return List.of();
        return mapper.selectList(
                new LambdaQueryWrapper<KnowledgeNode>()
                        .eq(KnowledgeNode::getParentId, node.getParentId())
                        .ne(KnowledgeNode::getId, id));
    }

    @Override
    public KnowledgeNode createNode(KnowledgeNode node) {
        // Auto-calculate level based on parent
        if (node.getParentId() != null) {
            KnowledgeNode parent = mapper.selectById(node.getParentId());
            if (parent != null) {
                node.setLevel(parent.getLevel() + 1);
            } else {
                node.setLevel(1);
            }
        } else {
            node.setLevel(1);
        }
        // Auto-assign orderIndex as max of existing siblings + 1
        var siblings = mapper.selectList(
                new LambdaQueryWrapper<KnowledgeNode>()
                        .eq(KnowledgeNode::getParentId, node.getParentId())
                        .orderByDesc(KnowledgeNode::getOrderIndex)
                        .last("LIMIT 1"));
        int maxOrder = siblings.isEmpty() ? -1 : siblings.get(0).getOrderIndex();
        node.setOrderIndex(maxOrder + 1);
        mapper.insert(node);
        return node;
    }

    @Override
    public KnowledgeNode updateNode(Long id, KnowledgeNode node) {
        node.setId(id);
        mapper.updateById(node);
        return node;
    }

    @Override
    public void deleteNode(Long id) {
        mapper.deleteById(id);
    }
}
