package com.lgraph.controller;

import com.lgraph.dto.request.ReviewRequest;
import com.lgraph.dto.response.ApiResponse;
import com.lgraph.entity.ReviewRecord;
import com.lgraph.security.SecurityUtils;
import com.lgraph.service.ReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    public ApiResponse<ReviewRecord> recordReview(@Valid @RequestBody ReviewRequest request) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(reviewService.recordReview(userId, request.getPageId(),
                request.getReviewRound(), request.getMasteryLevel(),
                request.getTimeSpentSeconds(), request.getNotes()));
    }

    @GetMapping("/subject/{subjectId}")
    public ApiResponse<Map<String, Object>> getProgress(@PathVariable Long subjectId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(reviewService.getSubjectProgress(subjectId, userId));
    }
}
