package com.lgraph.service;

import com.lgraph.entity.User;

import java.util.List;
import java.util.Map;

public interface AdminService {
    Map<String, Object> getDashboardStats();
    List<User> getUsers();
    void updateUserRole(Long userId, String role);
    void deleteUser(Long userId);
}
