package com.lgraph.service;

import com.lgraph.entity.Page;

import java.util.List;

public interface PageService {
    Page getPage(Long id);
    Page createPage(Long noteId, String title, String content);
    Page updatePage(Long id, String title, String content);
    void deletePage(Long id);
    void updateOrder(Long id, int newOrder);
    void attachToNode(Long pageId, Long nodeId);
    void detachFromNode(Long pageId, Long nodeId);
    List<Long> getAttachedNodeIds(Long pageId);
    List<Page> getPagesByNoteId(Long noteId);
}
