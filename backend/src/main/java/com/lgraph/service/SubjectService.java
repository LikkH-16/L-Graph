package com.lgraph.service;

import com.lgraph.dto.response.SubjectTreeResponse;
import com.lgraph.entity.Subject;

import java.util.List;

public interface SubjectService {
    List<Subject> getAllSubjects();
    Subject getSubject(Long id);
    SubjectTreeResponse getKnowledgeTree(Long subjectId);
}
