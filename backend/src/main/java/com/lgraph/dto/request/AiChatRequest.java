package com.lgraph.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class AiChatRequest {
    @NotBlank(message = "消息不能为空")
    private String message;
    private List<AiMessage> history;

    @Data
    public static class AiMessage {
        private String role;   // "user" | "assistant"
        private String content;
    }
}
