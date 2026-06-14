package com.lgraph.controller;

import com.lgraph.dto.response.ApiResponse;
import com.lgraph.dto.response.SubjectTreeResponse;
import com.lgraph.entity.Subject;
import com.lgraph.service.SubjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/subjects")
@RequiredArgsConstructor
public class SubjectController {

    private final SubjectService subjectService;

    @GetMapping
    public ApiResponse<List<Subject>> getAllSubjects() {
        return ApiResponse.success(subjectService.getAllSubjects());
    }

    @GetMapping("/{id}")
    public ApiResponse<Subject> getSubject(@PathVariable Long id) {
        return ApiResponse.success(subjectService.getSubject(id));
    }

    @GetMapping("/{id}/knowledge-tree")
    public ApiResponse<SubjectTreeResponse> getKnowledgeTree(@PathVariable Long id) {
        return ApiResponse.success(subjectService.getKnowledgeTree(id));
    }
}
