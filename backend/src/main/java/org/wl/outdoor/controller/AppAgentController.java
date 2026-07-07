package org.wl.outdoor.controller;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AgentChatDTO;
import org.wl.outdoor.service.AppAgentService;
import org.wl.outdoor.vo.AgentChatVO;

@RestController
@RequestMapping("/app/agent")
public class AppAgentController {
    private final AppAgentService appAgentService;

    public AppAgentController(AppAgentService appAgentService) {
        this.appAgentService = appAgentService;
    }

    @PostMapping("/chat")
    public Result<AgentChatVO> chat(@RequestBody AgentChatDTO dto) {
        return Result.success(appAgentService.chat(LoginUserContext.getUserId(), dto));
    }

    @PostMapping(value = "/chat", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public Result<AgentChatVO> chatWithImage(
            @RequestParam String message,
            @RequestPart(required = false) MultipartFile image
    ) {
        AgentChatDTO dto = new AgentChatDTO();
        dto.setMessage(message);
        return Result.success(appAgentService.chat(LoginUserContext.getUserId(), dto, image));
    }
}
