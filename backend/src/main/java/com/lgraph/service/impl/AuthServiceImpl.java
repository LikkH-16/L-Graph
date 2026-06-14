package com.lgraph.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lgraph.dto.request.LoginRequest;
import com.lgraph.dto.request.RegisterRequest;
import com.lgraph.dto.response.LoginResponse;
import com.lgraph.dto.response.UserDto;
import com.lgraph.entity.User;
import com.lgraph.entity.UserRole;
import com.lgraph.exception.BusinessException;
import com.lgraph.mapper.UserMapper;
import com.lgraph.security.JwtTokenProvider;
import com.lgraph.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserMapper userMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;

    @Override
    public LoginResponse login(LoginRequest request) {
        User user = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, request.getUsername()));
        if (user == null) {
            throw new BusinessException("用户名或密码错误");
        }
        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new BusinessException("用户名或密码错误");
        }

        String token = tokenProvider.generateToken(user.getId(), user.getUsername(), user.getRole().name());
        return new LoginResponse(token, UserDto.from(user));
    }

    @Override
    public LoginResponse register(RegisterRequest request) {
        var existing = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getUsername, request.getUsername()));
        if (existing != null) {
            throw new BusinessException("用户名已存在");
        }

        var emailExisting = userMapper.selectOne(
                new LambdaQueryWrapper<User>().eq(User::getEmail, request.getEmail()));
        if (emailExisting != null) {
            throw new BusinessException("邮箱已被注册");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        userMapper.insert(user);

        String token = tokenProvider.generateToken(user.getId(), user.getUsername(), user.getRole().name());
        return new LoginResponse(token, UserDto.from(user));
    }

    @Override
    public UserDto getCurrentUser(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        return UserDto.from(user);
    }
}
