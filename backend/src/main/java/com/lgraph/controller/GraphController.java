package com.lgraph.controller;

import com.lgraph.dto.response.ApiResponse;
import com.lgraph.dto.response.GraphDataResponse;
import com.lgraph.security.SecurityUtils;
import com.lgraph.service.GraphService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/graph")
@RequiredArgsConstructor
public class GraphController {

    private final GraphService graphService;

    @GetMapping("/subject/{subjectId}")
    public ApiResponse<GraphDataResponse> getSubjectGraph(@PathVariable Long subjectId) {
        return ApiResponse.success(graphService.getSubjectGraph(subjectId));
    }

    @GetMapping("/subject/{subjectId}/user")
    public ApiResponse<GraphDataResponse> getUserGraph(@PathVariable Long subjectId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(graphService.getUserGraph(subjectId, userId));
    }
}
