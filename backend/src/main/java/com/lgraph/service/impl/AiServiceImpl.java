package com.lgraph.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.lgraph.dto.request.AiChatRequest;
import com.lgraph.dto.response.AiChatResponse;
import com.lgraph.service.AiService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
@RequiredArgsConstructor
public class AiServiceImpl implements AiService {

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${app.ai.deepseek.api-key:}")
    private String apiKey;

    @Value("${app.ai.deepseek.model:deepseek-chat}")
    private String model;

    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";

    @Override
    public AiChatResponse chat(AiChatRequest request) {
        if (apiKey.isBlank()) {
            return new AiChatResponse("AI 服务未配置 API Key，请在 application.yml 中设置 app.ai.deepseek.api-key。");
        }

        try {
            // Build messages array
            List<Map<String, String>> messages = new ArrayList<>();
            messages.add(Map.of("role", "system", "content",
                    "你是 L-Graph 学习助教，帮助用户学习计算机考研 408 课程（数据结构、计组、操作系统、计算机网络）。请用中文简洁回答。"));

            if (request.getHistory() != null) {
                for (var msg : request.getHistory()) {
                    messages.add(Map.of("role", msg.getRole(), "content", msg.getContent()));
                }
            }
            messages.add(Map.of("role", "user", "content", request.getMessage()));

            Map<String, Object> body = new HashMap<>();
            body.put("model", model);
            body.put("messages", messages);
            body.put("max_tokens", 1024);
            body.put("temperature", 0.7);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.exchange(API_URL, HttpMethod.POST, entity, String.class);

            JsonNode root = objectMapper.readTree(response.getBody());
            String reply = root.path("choices").get(0).path("message").path("content").asText("AI 返回了空回复");

            return new AiChatResponse(reply);
        } catch (Exception e) {
            return new AiChatResponse("AI 调用出错：" + e.getMessage());
        }
    }
}
