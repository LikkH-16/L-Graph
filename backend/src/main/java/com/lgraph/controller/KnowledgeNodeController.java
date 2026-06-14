package com.lgraph.controller;

import com.lgraph.dto.response.ApiResponse;
import com.lgraph.entity.KnowledgeNode;
import com.lgraph.service.KnowledgeNodeService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/knowledge-nodes")
@RequiredArgsConstructor
public class KnowledgeNodeController {

    private final KnowledgeNodeService nodeService;

    @GetMapping("/{id}")
    public ApiResponse<KnowledgeNode> getNode(@PathVariable Long id) {
        return ApiResponse.success(nodeService.getNode(id));
    }

    @GetMapping("/{id}/children")
    public ApiResponse<List<KnowledgeNode>> getChildren(@PathVariable Long id) {
        return ApiResponse.success(nodeService.getChildren(id));
    }

    @GetMapping("/{id}/siblings")
    public ApiResponse<List<KnowledgeNode>> getSiblings(@PathVariable Long id) {
        return ApiResponse.success(nodeService.getSiblings(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<KnowledgeNode> create(@RequestBody KnowledgeNode node) {
        return ApiResponse.success(nodeService.createNode(node));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<KnowledgeNode> update(@PathVariable Long id, @RequestBody KnowledgeNode node) {
        return ApiResponse.success(nodeService.updateNode(id, node));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        nodeService.deleteNode(id);
        return ApiResponse.success("删除成功", null);
    }
}
