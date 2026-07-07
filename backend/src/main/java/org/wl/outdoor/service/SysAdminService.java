package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.AdminCreateDTO;
import org.wl.outdoor.dto.AdminQueryDTO;
import org.wl.outdoor.dto.AdminResetPasswordDTO;
import org.wl.outdoor.vo.SysAdminVO;

public interface SysAdminService {
    PageResult<SysAdminVO> list(AdminQueryDTO dto);

    void create(AdminCreateDTO dto, Long currentAdminId, String currentRole);

    void enable(Long id, Long currentAdminId, String currentRole);

    void disable(Long id, Long currentAdminId, String currentRole);

    void resetPassword(Long id, AdminResetPasswordDTO dto, Long currentAdminId, String currentRole);
}
