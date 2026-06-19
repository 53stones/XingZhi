package org.wl.outdoor.service;

import org.wl.outdoor.dto.AgentChatDTO;
import org.wl.outdoor.vo.AgentChatVO;
import org.springframework.web.multipart.MultipartFile;

public interface AppAgentService {
    AgentChatVO chat(Long userId, AgentChatDTO dto);

    AgentChatVO chat(Long userId, AgentChatDTO dto, MultipartFile image);
}
