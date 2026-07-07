package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpEventQueryDTO;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

public interface HelpEventService {
    PageResult<HelpEventVO> list(HelpEventQueryDTO dto);

    HelpEventDetailVO detail(Long id);
}
