package com.lgraph.service.impl;

import com.lgraph.entity.User;
import com.lgraph.entity.UserRole;
import com.lgraph.exception.BusinessException;
import com.lgraph.mapper.KnowledgeNodeMapper;
import com.lgraph.mapper.NoteMapper;
import com.lgraph.mapper.PageMapper;
import com.lgraph.mapper.ReviewRecordMapper;
import com.lgraph.mapper.SubjectMapper;
import com.lgraph.mapper.UserMapper;
import com.lgraph.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

    private final UserMapper userMapper;
    private final SubjectMapper subjectMapper;
    private final KnowledgeNodeMapper knowledgeNodeMapper;
    private final NoteMapper noteMapper;
    private final PageMapper pageMapper;
    private final ReviewRecordMapper reviewRecordMapper;

    @Override
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("userCount", userMapper.selectCount(null));
        stats.put("subjectCount", subjectMapper.selectCount(null));
        stats.put("knowledgeNodeCount", knowledgeNodeMapper.selectCount(null));
        stats.put("noteCount", noteMapper.selectCount(null));
        stats.put("pageCount", pageMapper.selectCount(null));
        stats.put("reviewCount", reviewRecordMapper.selectCount(null));
        return stats;
    }

    @Override
    public List<User> getUsers() {
        return userMapper.selectList(null);
    }

    @Override
    public void updateUserRole(Long userId, String role) {
        User user = userMapper.selectById(userId);
        if (user == null) throw new BusinessException("用户不存在");
        user.setRole(UserRole.valueOf(role));
        userMapper.updateById(user);
    }

    @Override
    public void deleteUser(Long userId) {
        userMapper.deleteById(userId);
    }
}
