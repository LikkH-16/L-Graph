package com.lgraph.controller;

import com.lgraph.dto.request.NoteCreateRequest;
import com.lgraph.dto.response.ApiResponse;
import com.lgraph.entity.Note;
import com.lgraph.entity.Page;
import com.lgraph.security.SecurityUtils;
import com.lgraph.service.NoteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/notes")
@RequiredArgsConstructor
public class NoteController {

    private final NoteService noteService;

    @GetMapping
    public ApiResponse<List<Note>> getNotes(@RequestParam Long subjectId) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(noteService.getNotesBySubject(userId, subjectId));
    }

    @PostMapping
    public ApiResponse<Note> create(@Valid @RequestBody NoteCreateRequest request) {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(noteService.createNote(userId, request.getSubjectId(), request.getTitle()));
    }

    @GetMapping("/{id}")
    public ApiResponse<List<Page>> getNoteWithPages(@PathVariable Long id) {
        return ApiResponse.success(noteService.getPages(id));
    }

    @PutMapping("/{id}")
    public ApiResponse<Note> update(@PathVariable Long id, @RequestBody NoteCreateRequest request) {
        return ApiResponse.success(noteService.updateNote(id, request.getTitle()));
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Long id) {
        noteService.deleteNote(id);
        return ApiResponse.success("删除成功", null);
    }
}
