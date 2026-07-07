package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.*;
import org.wl.outdoor.common.LoginAdminContext;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AdminCreateDTO;
import org.wl.outdoor.dto.AdminQueryDTO;
import org.wl.outdoor.dto.AdminResetPasswordDTO;
import org.wl.outdoor.service.SysAdminService;
import org.wl.outdoor.vo.SysAdminVO;

@RestController
@RequestMapping("/admin/admins")
public class SysAdminController {

    private final SysAdminService sysAdminService;

    public SysAdminController(SysAdminService sysAdminService) {
        this.sysAdminService = sysAdminService;
    }

    @GetMapping
    public Result<PageResult<SysAdminVO>> list(AdminQueryDTO dto) {
        checkSuperAdmin();
        return Result.success(sysAdminService.list(dto));
    }

    @PostMapping
    public Result<Void> create(@RequestBody AdminCreateDTO dto) {
        checkSuperAdmin();

        sysAdminService.create(
                dto,
                LoginAdminContext.getAdminId(),
                LoginAdminContext.getRole()
        );

        return Result.success();
    }

    @PutMapping("/{id}/enable")
    public Result<Void> enable(@PathVariable Long id) {
        checkSuperAdmin();

        sysAdminService.enable(
                id,
                LoginAdminContext.getAdminId(),
                LoginAdminContext.getRole()
        );

        return Result.success();
    }

    @PutMapping("/{id}/disable")
    public Result<Void> disable(@PathVariable Long id) {
        checkSuperAdmin();

        sysAdminService.disable(
                id,
                LoginAdminContext.getAdminId(),
                LoginAdminContext.getRole()
        );

        return Result.success();
    }

    @PutMapping("/{id}/reset-password")
    public Result<Void> resetPassword(
            @PathVariable Long id,
            @RequestBody AdminResetPasswordDTO dto
    ) {
        checkSuperAdmin();

        sysAdminService.resetPassword(
                id,
                dto,
                LoginAdminContext.getAdminId(),
                LoginAdminContext.getRole()
        );

        return Result.success();
    }

    private void checkSuperAdmin() {
        if (!LoginAdminContext.isSuperAdmin()) {
            throw new RuntimeException("只有超级管理员可以管理管理员账号");
        }
    }
}