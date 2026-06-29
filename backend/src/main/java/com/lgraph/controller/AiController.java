package com.lgraph.controller;

import com.lgraph.dto.request.AiChatRequest;
import com.lgraph.dto.response.AiChatResponse;
import com.lgraph.dto.response.ApiResponse;
import com.lgraph.service.AiService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/ai")
@RequiredArgsConstructor
public class AiController {

    private final AiService aiService;

    @PostMapping("/chat")
    public ApiResponse<AiChatResponse> chat(@Valid @RequestBody AiChatRequest request) {
        return ApiResponse.success(aiService.chat(request));
    }
}
