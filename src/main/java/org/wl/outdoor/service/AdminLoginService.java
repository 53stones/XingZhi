package org.wl.outdoor.service;

import org.wl.outdoor.dto.AdminLoginDTO;
import org.wl.outdoor.vo.AdminLoginVO;

public interface AdminLoginService {
    AdminLoginVO login(AdminLoginDTO dto);
}
