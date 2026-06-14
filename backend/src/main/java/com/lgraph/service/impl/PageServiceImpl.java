package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.entity.Page;
import com.lgraph.entity.PageKnowledgeNode;
import com.lgraph.mapper.PageKnowledgeNodeMapper;
import com.lgraph.mapper.PageMapper;
import com.lgraph.service.PageService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PageServiceImpl implements PageService {

    private final PageMapper pageMapper;
    private final PageKnowledgeNodeMapper pknMapper;

    @Override
    public List<Page> getPagesByNoteId(Long noteId) {
        return pageMapper.selectList(
                new LambdaQueryWrapper<Page>()
                        .eq(Page::getNoteId, noteId)
                        .orderByAsc(Page::getOrderIndex));
    }

    @Override
    public Page getPage(Long id) {
        return pageMapper.selectById(id);
    }

    @Override
    public Page createPage(Long noteId, String title, String content) {
        Page page = new Page();
        page.setNoteId(noteId);
        page.setTitle(title);
        page.setContent(content);
        page.setOrderIndex(nextOrderIndex(noteId));
        page.setReviewRound(0);
        page.setMasteryLevel(0);
        pageMapper.insert(page);
        return page;
    }

    @Override
    public Page updatePage(Long id, String title, String content) {
        Page page = pageMapper.selectById(id);
        if (page != null) {
            if (title != null) page.setTitle(title);
            if (content != null) page.setContent(content);
            pageMapper.updateById(page);
        }
        return page;
    }

    @Override
    public void deletePage(Long id) {
        pageMapper.deleteById(id);
    }

    @Override
    public void updateOrder(Long id, int newOrder) {
        Page page = pageMapper.selectById(id);
        if (page != null) {
            page.setOrderIndex(newOrder);
            pageMapper.updateById(page);
        }
    }

    @Override
    public void attachToNode(Long pageId, Long nodeId) {
        var existing = pknMapper.selectList(
                new LambdaQueryWrapper<PageKnowledgeNode>()
                        .eq(PageKnowledgeNode::getPageId, pageId)
                        .eq(PageKnowledgeNode::getKnowledgeNodeId, nodeId));
        if (existing.isEmpty()) {
            var pkn = new PageKnowledgeNode();
            pkn.setPageId(pageId);
            pkn.setKnowledgeNodeId(nodeId);
            pkn.setCreatedAt(LocalDateTime.now());
            pknMapper.insert(pkn);
        }
    }

    @Override
    public void detachFromNode(Long pageId, Long nodeId) {
        pknMapper.delete(
                new LambdaQueryWrapper<PageKnowledgeNode>()
                        .eq(PageKnowledgeNode::getPageId, pageId)
                        .eq(PageKnowledgeNode::getKnowledgeNodeId, nodeId));
    }

    @Override
    public List<Long> getAttachedNodeIds(Long pageId) {
        return pknMapper.selectList(
                        new LambdaQueryWrapper<PageKnowledgeNode>()
                                .eq(PageKnowledgeNode::getPageId, pageId))
                .stream().map(PageKnowledgeNode::getKnowledgeNodeId).toList();
    }

    private int nextOrderIndex(Long noteId) {
        var pages = pageMapper.selectList(
                new LambdaQueryWrapper<Page>()
                        .eq(Page::getNoteId, noteId)
                        .orderByDesc(Page::getOrderIndex)
                        .last("LIMIT 1"));
        return pages.isEmpty() ? 0 : pages.get(0).getOrderIndex() + 1;
    }
}
