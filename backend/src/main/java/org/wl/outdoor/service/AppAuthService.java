package org.wl.outdoor.service;

import org.wl.outdoor.dto.AppUserLoginDTO;
import org.wl.outdoor.dto.AppUserRegisterDTO;
import org.wl.outdoor.vo.AppUserLoginVO;

public interface AppAuthService {
    AppUserLoginVO register(AppUserRegisterDTO dto);
    AppUserLoginVO login(AppUserLoginDTO dto);
}
