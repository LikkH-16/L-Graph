package com.lgraph.service;

import com.lgraph.entity.Note;
import com.lgraph.entity.Page;

import java.util.List;

public interface NoteService {
    List<Note> getNotesBySubject(Long userId, Long subjectId);
    Note createNote(Long userId, Long subjectId, String title);
    Note updateNote(Long noteId, String title);
    void deleteNote(Long noteId);
    List<Page> getPages(Long noteId);
}
