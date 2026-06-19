package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpResponseQueryDTO;
import org.wl.outdoor.entity.HelpResponse;
import org.wl.outdoor.vo.HelpResponseVO;

public interface HelpResponseService {
    PageResult<HelpResponseVO> list(HelpResponseQueryDTO dto);
}
