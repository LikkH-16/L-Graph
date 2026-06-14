package com.lgraph.service;

import com.lgraph.entity.KnowledgeNode;

import java.util.List;

public interface KnowledgeNodeService {
    KnowledgeNode getNode(Long id);
    List<KnowledgeNode> getChildren(Long id);
    List<KnowledgeNode> getSiblings(Long id);
    KnowledgeNode createNode(KnowledgeNode node);
    KnowledgeNode updateNode(Long id, KnowledgeNode node);
    void deleteNode(Long id);
}
