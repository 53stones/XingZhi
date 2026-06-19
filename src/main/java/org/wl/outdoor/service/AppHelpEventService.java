package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.dto.AppNearbyHelpQueryDTO;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

public interface AppHelpEventService {
    HelpEventDetailVO create(Long userId, AppHelpEventCreateDTO dto);
    PageResult<HelpEventVO> mine(Long userId, Integer page, Integer size);
    PageResult<HelpEventVO> nearby(Long userId, AppNearbyHelpQueryDTO dto);
    HelpEventDetailVO latest(Long userId);
    HelpEventDetailVO detail(Long userId, Long id);
    void cancel(Long userId, Long id);
}
