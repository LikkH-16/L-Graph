package com.lgraph.controller;

import com.lgraph.dto.request.LoginRequest;
import com.lgraph.dto.request.RegisterRequest;
import com.lgraph.dto.response.ApiResponse;
import com.lgraph.dto.response.LoginResponse;
import com.lgraph.dto.response.UserDto;
import com.lgraph.security.SecurityUtils;
import com.lgraph.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ApiResponse<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        return ApiResponse.success(authService.login(request));
    }

    @PostMapping("/register")
    public ApiResponse<LoginResponse> register(@Valid @RequestBody RegisterRequest request) {
        return ApiResponse.success(authService.register(request));
    }

    @GetMapping("/me")
    public ApiResponse<UserDto> me() {
        Long userId = SecurityUtils.getCurrentUserId();
        if (userId == null) {
            return ApiResponse.error(401, "未认证");
        }
        return ApiResponse.success(authService.getCurrentUser(userId));
    }
}
