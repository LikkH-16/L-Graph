package com.lgraph.service;

import com.lgraph.dto.request.LoginRequest;
import com.lgraph.dto.request.RegisterRequest;
import com.lgraph.dto.response.LoginResponse;
import com.lgraph.dto.response.UserDto;

public interface AuthService {
    LoginResponse login(LoginRequest request);
    LoginResponse register(RegisterRequest request);
    UserDto getCurrentUser(Long userId);
}
