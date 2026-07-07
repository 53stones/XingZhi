package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.*;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.UserQueryDTO;
import org.wl.outdoor.entity.EmergencyContact;
import org.wl.outdoor.service.AppUserService;
import org.wl.outdoor.vo.AppUserDetailVO;
import org.wl.outdoor.vo.AppUserVO;

@RestController
@RequestMapping("/admin/users")
public class AppUserController {
    private final AppUserService appUserService;

    public AppUserController(AppUserService appUserService) {
        this.appUserService = appUserService;
    }

    @GetMapping
    public Result<PageResult<AppUserVO>> list(UserQueryDTO dto) {
        return Result.success(appUserService.list(dto));
    }

    @GetMapping("/{id}")
    public Result<AppUserDetailVO> detail(@PathVariable Long id) {
        return Result.success(appUserService.detail(id));
    }

    @PutMapping("/{id}/enable")
    public Result<Void> enable(@PathVariable Long id) {
        appUserService.enable(id);
        return Result.success();
    }

    @PutMapping("/{id}/disable")
    public Result<Void> disable(@PathVariable Long id) {
        appUserService.disable(id);
        return Result.success();
    }


    }
