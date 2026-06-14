package com.lgraph.controller;

import com.lgraph.dto.response.ApiResponse;
import com.lgraph.entity.User;
import com.lgraph.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final AdminService adminService;

    @GetMapping("/dashboard")
    public ApiResponse<Map<String, Object>> dashboard() {
        return ApiResponse.success(adminService.getDashboardStats());
    }

    @GetMapping("/users")
    public ApiResponse<List<User>> getUsers() {
        return ApiResponse.success(adminService.getUsers());
    }

    @PutMapping("/users/{id}/role")
    public ApiResponse<Void> updateRole(@PathVariable Long id, @RequestBody Map<String, String> body) {
        adminService.updateUserRole(id, body.get("role"));
        return ApiResponse.success("角色已更新", null);
    }

    @DeleteMapping("/users/{id}")
    public ApiResponse<Void> deleteUser(@PathVariable Long id) {
        adminService.deleteUser(id);
        return ApiResponse.success("用户已删除", null);
    }
}
