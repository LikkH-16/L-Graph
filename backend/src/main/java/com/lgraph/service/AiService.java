package com.lgraph.service;

import com.lgraph.dto.request.AiChatRequest;
import com.lgraph.dto.response.AiChatResponse;

public interface AiService {
    AiChatResponse chat(AiChatRequest request);
}
