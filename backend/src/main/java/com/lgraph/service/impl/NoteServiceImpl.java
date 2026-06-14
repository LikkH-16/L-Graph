package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.entity.Note;
import com.lgraph.entity.NoteStatus;
import com.lgraph.entity.Page;
import com.lgraph.exception.BusinessException;
import com.lgraph.mapper.NoteMapper;
import com.lgraph.mapper.PageMapper;
import com.lgraph.service.NoteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NoteServiceImpl implements NoteService {

    private final NoteMapper noteMapper;
    private final PageMapper pageMapper;

    @Override
    public List<Note> getNotesBySubject(Long userId, Long subjectId) {
        return noteMapper.selectList(
                new LambdaQueryWrapper<Note>()
                        .eq(Note::getUserId, userId)
                        .eq(Note::getSubjectId, subjectId));
    }

    @Override
    public Note createNote(Long userId, Long subjectId, String title) {
        Note note = new Note();
        note.setUserId(userId);
        note.setSubjectId(subjectId);
        note.setTitle(title);
        note.setStatus(NoteStatus.DRAFT);
        noteMapper.insert(note);
        return note;
    }

    @Override
    public Note updateNote(Long noteId, String title) {
        Note note = noteMapper.selectById(noteId);
        if (note == null) {
            throw new BusinessException("笔记不存在");
        }
        note.setTitle(title);
        noteMapper.updateById(note);
        return note;
    }

    @Override
    public void deleteNote(Long noteId) {
        noteMapper.deleteById(noteId);
    }

    @Override
    public List<Page> getPages(Long noteId) {
        return pageMapper.selectList(
                new LambdaQueryWrapper<Page>()
                        .eq(Page::getNoteId, noteId)
                        .orderByAsc(Page::getOrderIndex));
    }
}
