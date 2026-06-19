package org.wl.outdoor.serviceImpl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.wl.outdoor.agent.AgentToolService;
import org.wl.outdoor.dto.AgentChatDTO;
import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.service.AppAgentService;
import org.wl.outdoor.vo.AgentChatVO;

import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Service
public class AppAgentServiceImpl implements AppAgentService {
    private final AgentToolService agentToolService;
    private final ObjectMapper objectMapper;
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${agent.dify.enabled:false}")
    private boolean difyEnabled;

    @Value("${agent.dify.api-url:}")
    private String difyApiUrl;

    @Value("${agent.dify.file-upload-url:}")
    private String difyFileUploadUrl;

    @Value("${agent.dify.api-key:}")
    private String difyApiKey;

    @Value("${agent.dify.user-prefix:xingzhi-user-}")
    private String difyUserPrefix;

    public AppAgentServiceImpl(AgentToolService agentToolService, ObjectMapper objectMapper) {
        this.agentToolService = agentToolService;
        this.objectMapper = objectMapper;
    }

    @Override
    public AgentChatVO chat(Long userId, AgentChatDTO dto) {
        return chat(userId, dto, null);
    }

    @Override
    public AgentChatVO chat(Long userId, AgentChatDTO dto, MultipartFile image) {
        if (dto == null || !StringUtils.hasText(dto.getMessage())) {
            throw new RuntimeException("消息不能为空");
        }
        String message = dto.getMessage();
        AgentChatVO vo = new AgentChatVO();

        if (containsAny(message, "帮我求助", "发起求助")) {
            AppHelpEventCreateDTO create = new AppHelpEventCreateDTO();
            create.setHelpMode(2);
            create.setHelpType("AI 协助求助");
            create.setEmergencyLevel(2);
            create.setDescription(message);
            create.setRadius(3000);
            vo.setCreatedHelpEvent(agentToolService.createHelpEvent(userId, create));
            vo.setReply("我已经为你创建了一条求助事件。请尽快补充位置、图片和更详细的情况。");
            vo.setSuggestHelp(true);
            return vo;
        }

        if (difyEnabled && StringUtils.hasText(difyApiUrl) && StringUtils.hasText(difyApiKey)) {
            String reply = requestDify(userId, message, image);
            if (StringUtils.hasText(reply)) {
                vo.setReply(reply);
                vo.setSuggestHelp(containsAny(message, "求助", "救命", "受伤", "危险", "迷路"));
                return vo;
            }
        }

        return fallbackReply(message);
    }

    private String requestDify(Long userId, String message, MultipartFile image) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(difyApiKey);

            String user = difyUserPrefix + userId;
            Map<String, Object> body = new HashMap<>();
            body.put("inputs", Map.of());
            body.put("query", message);
            body.put("response_mode", "blocking");
            body.put("conversation_id", "");
            body.put("user", user);

            String uploadFileId = uploadImageToDify(user, image);
            if (StringUtils.hasText(uploadFileId)) {
                body.put("files", List.of(Map.of(
                        "type", "image",
                        "transfer_method", "local_file",
                        "upload_file_id", uploadFileId
                )));
            }

            String response = restTemplate.postForObject(
                    difyApiUrl,
                    new HttpEntity<>(body, headers),
                    String.class
            );
            return parseDifyReply(response);
        } catch (RestClientException ex) {
            return null;
        } catch (Exception ex) {
            return null;
        }
    }

    private String uploadImageToDify(String user, MultipartFile image) throws IOException {
        if (image == null || image.isEmpty()) {
            return null;
        }
        if (!StringUtils.hasText(difyFileUploadUrl)) {
            return null;
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        headers.setBearerAuth(difyApiKey);

        ByteArrayResource imageResource = new ByteArrayResource(image.getBytes()) {
            @Override
            public String getFilename() {
                return StringUtils.hasText(image.getOriginalFilename())
                        ? image.getOriginalFilename()
                        : "agent-image.jpg";
            }
        };

        HttpHeaders fileHeaders = new HttpHeaders();
        fileHeaders.setContentType(MediaType.parseMediaType(
                StringUtils.hasText(image.getContentType()) ? image.getContentType() : MediaType.IMAGE_JPEG_VALUE
        ));

        MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
        body.add("user", user);
        body.add("file", new HttpEntity<>(imageResource, fileHeaders));

        String response = restTemplate.postForObject(
                difyFileUploadUrl,
                new HttpEntity<>(body, headers),
                String.class
        );
        if (!StringUtils.hasText(response)) {
            return null;
        }

        JsonNode root = objectMapper.readTree(response);
        JsonNode id = root.get("id");
        return id == null ? null : id.asText();
    }

    private String parseDifyReply(String response) throws Exception {
        if (!StringUtils.hasText(response)) {
            return null;
        }
        JsonNode root = objectMapper.readTree(response);
        JsonNode answer = root.get("answer");
        if (answer != null && StringUtils.hasText(answer.asText())) {
            return answer.asText();
        }

        JsonNode outputs = root.path("data").path("outputs");
        if (outputs.isObject()) {
            for (String field : new String[]{"answer", "text", "result", "output", "reply"}) {
                JsonNode value = outputs.get(field);
                if (value != null && StringUtils.hasText(value.asText())) {
                    return value.asText();
                }
            }
        }
        return null;
    }

    private AgentChatVO fallbackReply(String message) {
        AgentChatVO vo = new AgentChatVO();
        if (containsAny(message, "大量出血", "呼吸困难", "意识不清", "胸痛")) {
            vo.setReply("这可能是紧急情况。请立即拨打急救电话，并尽快发起求助；如果有大量出血，先持续加压止血。");
            vo.setSuggestHelp(true);
            return vo;
        }
        if (containsAny(message, "扭伤", "崴脚")) {
            vo.setReply("先停止活动，抬高患肢，尽快冷敷，每次约 15-20 分钟；如果不能负重、明显变形或疼痛很重，建议尽快求助。");
            vo.setSuggestHelp(true);
            return vo;
        }
        if (containsAny(message, "迷路", "找不到路")) {
            vo.setReply("先停在安全位置，保存体力和电量，查看是否能回到已知路线；如果天色变暗、受伤或无法判断方向，建议立即发起求助。");
            vo.setSuggestHelp(true);
            return vo;
        }
        vo.setReply("我可以帮助你判断风险、给出基础应急建议，或协助发起求助。请告诉我你现在遇到了什么情况。");
        vo.setSuggestHelp(false);
        return vo;
    }

    private boolean containsAny(String text, String... keywords) {
        for (String keyword : keywords) {
            if (text.contains(keyword)) {
                return true;
            }
        }
        return false;
    }
}
