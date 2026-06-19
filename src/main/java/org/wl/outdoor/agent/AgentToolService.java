package org.wl.outdoor.agent;

import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.vo.HelpEventDetailVO;

public interface AgentToolService {
    HelpEventDetailVO createHelpEvent(Long userId, AppHelpEventCreateDTO dto);
    HelpEventDetailVO getHelpEventDetail(Long userId, Long helpEventId);
}
