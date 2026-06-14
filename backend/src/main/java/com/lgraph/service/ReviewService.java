package com.lgraph.service;

import com.lgraph.entity.ReviewRecord;

import java.util.Map;

public interface ReviewService {
    ReviewRecord recordReview(Long userId, Long pageId, int round, int mastery, int timeSpent, String notes);
    Map<String, Object> getSubjectProgress(Long subjectId, Long userId);
}
