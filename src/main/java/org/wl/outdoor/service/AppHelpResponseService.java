package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.vo.HelpResponseVO;

public interface AppHelpResponseService {
    HelpResponseVO respond(Long userId, Long helpId);
    void cancel(Long userId, Long responseId);
    PageResult<HelpResponseVO> mine(Long userId, Integer page, Integer size);
}
