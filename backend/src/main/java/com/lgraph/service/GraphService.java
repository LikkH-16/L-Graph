package com.lgraph.service;

import com.lgraph.dto.response.GraphDataResponse;

public interface GraphService {
    GraphDataResponse getSubjectGraph(Long subjectId);
    GraphDataResponse getUserGraph(Long subjectId, Long userId);
}
