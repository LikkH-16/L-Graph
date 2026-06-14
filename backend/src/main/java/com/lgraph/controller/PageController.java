package com.lgraph.controller;

import com.lgraph.dto.request.PageCreateRequest;
import com.lgraph.dto.request.PageUpdateRequest;
import com.lgraph.dto.response.ApiResponse;
import com.lgraph.entity.Page;
import com.lgraph.service.PageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/pages")
@RequiredArgsConstructor
public class PageController {

    private final PageService pageService;

    @GetMapping
    public ApiResponse<List<Page>> getPages(@RequestParam Long noteId) {
        return ApiResponse.success(pageService.getPagesByNoteId(noteId));
    }

    @PostMapping
    public ApiResponse<Page> create(@Valid @RequestBody PageCreateRequest request) {
        return ApiResponse.success(pageService.createPage(request.getNoteId(), request.getTitle(),
                request.getContent() != null ? request.getContent() : ""));
    }

    @GetMapping("/{id}")
    public ApiResponse<Page> getPage(@PathVariable Long id) {
        return ApiResponse.success(pageService.getPage(id));
    }

    @PutMapping("/{id}")
    public ApiResponse<Page> update(@PathVariable Long id, @RequestBody PageUpdateRequest request) {
        return ApiResponse.success(pageService.updatePage(id, request.getTitle(), request.getContent()));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        pageService.deletePage(id);
        return ApiResponse.success("删除成功", null);
    }

    @PostMapping("/{pageId}/attach/{nodeId}")
    public ApiResponse<Void> attach(@PathVariable Long pageId, @PathVariable Long nodeId) {
        pageService.attachToNode(pageId, nodeId);
        return ApiResponse.success("挂载成功", null);
    }

    @DeleteMapping("/{pageId}/detach/{nodeId}")
    public ApiResponse<Void> detach(@PathVariable Long pageId, @PathVariable Long nodeId) {
        pageService.detachFromNode(pageId, nodeId);
        return ApiResponse.success("取消挂载成功", null);
    }

    @GetMapping("/{pageId}/knowledge-nodes")
    public ApiResponse<List<Long>> getAttachedNodes(@PathVariable Long pageId) {
        return ApiResponse.success(pageService.getAttachedNodeIds(pageId));
    }
}
