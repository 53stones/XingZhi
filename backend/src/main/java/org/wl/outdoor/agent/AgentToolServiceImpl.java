package org.wl.outdoor.agent;

import org.springframework.stereotype.Service;
import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.service.AppHelpEventService;
import org.wl.outdoor.vo.HelpEventDetailVO;

@Service
public class AgentToolServiceImpl implements AgentToolService {
    private final AppHelpEventService appHelpEventService;

    public AgentToolServiceImpl(AppHelpEventService appHelpEventService) {
        this.appHelpEventService = appHelpEventService;
    }

    @Override
    public HelpEventDetailVO createHelpEvent(Long userId, AppHelpEventCreateDTO dto) {
        return appHelpEventService.create(userId, dto);
    }

    @Override
    public HelpEventDetailVO getHelpEventDetail(Long userId, Long helpEventId) {
        return appHelpEventService.detail(userId, helpEventId);
    }
}
