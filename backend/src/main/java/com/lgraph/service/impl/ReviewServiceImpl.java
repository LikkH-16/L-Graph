package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.entity.Note;
import com.lgraph.entity.Page;
import com.lgraph.entity.ReviewRecord;
import com.lgraph.mapper.NoteMapper;
import com.lgraph.mapper.PageMapper;
import com.lgraph.mapper.ReviewRecordMapper;
import com.lgraph.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRecordMapper reviewMapper;
    private final PageMapper pageMapper;
    private final NoteMapper noteMapper;

    @Override
    public ReviewRecord recordReview(Long userId, Long pageId, int round, int mastery, int timeSpent, String notes) {
        ReviewRecord record = new ReviewRecord();
        record.setUserId(userId);
        record.setPageId(pageId);
        record.setReviewRound(round);
        record.setMasteryLevel(mastery);
        record.setTimeSpentSeconds(timeSpent);
        record.setNotes(notes);
        record.setReviewedAt(LocalDateTime.now());
        reviewMapper.insert(record);

        // Update the page's review progress
        Page page = pageMapper.selectById(pageId);
        if (page != null) {
            page.setReviewRound(round);
            page.setMasteryLevel(mastery);
            page.setLastReviewedAt(LocalDateTime.now());
            pageMapper.updateById(page);
        }

        return record;
    }

    @Override
    public Map<String, Object> getSubjectProgress(Long subjectId, Long userId) {
        // Get all notes for this subject+user, then pages, then review records
        var notes = noteMapper.selectList(
                new LambdaQueryWrapper<Note>()
                        .eq(Note::getUserId, userId)
                        .eq(Note::getSubjectId, subjectId));
        var noteIds = notes.stream().map(Note::getId).toList();

        List<Page> pages = List.of();
        if (!noteIds.isEmpty()) {
            pages = pageMapper.selectList(
                    new LambdaQueryWrapper<Page>().in(Page::getNoteId, noteIds));
        }
        var pageIds = pages.stream().map(Page::getId).collect(Collectors.toSet());

        int totalPages = pages.size();
        int pagesReviewed = 0;
        int round1Count = 0, round2Count = 0, round3Count = 0, masteredCount = 0;

        if (!pageIds.isEmpty()) {
            var reviews = reviewMapper.selectList(
                    new LambdaQueryWrapper<ReviewRecord>()
                            .eq(ReviewRecord::getUserId, userId)
                            .in(ReviewRecord::getPageId, pageIds));

            // Group by page, take max round for each
            var pageMaxRound = new HashMap<Long, Integer>();
            var pageMaxMastery = new HashMap<Long, Integer>();
            for (var r : reviews) {
                pageMaxRound.merge(r.getPageId(), r.getReviewRound(), Math::max);
                pageMaxMastery.merge(r.getPageId(), r.getMasteryLevel(), Math::max);
            }
            pagesReviewed = pageMaxRound.size();
            for (var round : pageMaxRound.values()) {
                if (round >= 1) round1Count++;
                if (round >= 2) round2Count++;
                if (round >= 3) round3Count++;
            }
            masteredCount = (int) pageMaxMastery.values().stream().filter(m -> m >= 3).count();
        }

        int completionPercent = totalPages > 0 ? (pagesReviewed * 100) / totalPages : 0;

        Map<String, Object> stats = new HashMap<>();
        stats.put("subjectId", subjectId);
        stats.put("totalPages", totalPages);
        stats.put("pagesReviewed", pagesReviewed);
        stats.put("round1Count", round1Count);
        stats.put("round2Count", round2Count);
        stats.put("round3Count", round3Count);
        stats.put("masteredCount", masteredCount);
        stats.put("completionPercent", completionPercent);
        return stats;
    }
}
