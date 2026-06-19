package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.UserQueryDTO;
import org.wl.outdoor.vo.AppUserDetailVO;
import org.wl.outdoor.vo.AppUserVO;

public interface AppUserService {
    PageResult<AppUserVO> list(UserQueryDTO dto);

    AppUserDetailVO detail(Long id);

    void enable(Long id);

    void disable(Long id);
}
