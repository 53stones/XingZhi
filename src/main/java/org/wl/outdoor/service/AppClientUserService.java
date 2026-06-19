package org.wl.outdoor.service;

import org.wl.outdoor.dto.AppUserProfileUpdateDTO;
import org.wl.outdoor.vo.AppUserDetailVO;

public interface AppClientUserService {
    AppUserDetailVO profile(Long userId);
    AppUserDetailVO updateProfile(Long userId, AppUserProfileUpdateDTO dto);
    AppUserDetailVO updateHelperStatus(Long userId, Integer isHelper);
}
