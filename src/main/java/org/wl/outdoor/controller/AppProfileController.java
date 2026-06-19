package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.*;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AppUserProfileUpdateDTO;
import org.wl.outdoor.service.AppClientUserService;
import org.wl.outdoor.vo.AppUserDetailVO;

@RestController
@RequestMapping("/app")
public class AppProfileController {
    private final AppClientUserService appClientUserService;

    public AppProfileController(AppClientUserService appClientUserService) {
        this.appClientUserService = appClientUserService;
    }

    @GetMapping("/profile")
    public Result<AppUserDetailVO> profile() {
        return Result.success(appClientUserService.profile(LoginUserContext.getUserId()));
    }

    @PutMapping("/profile")
    public Result<AppUserDetailVO> updateProfile(@RequestBody AppUserProfileUpdateDTO dto) {
        return Result.success(appClientUserService.updateProfile(LoginUserContext.getUserId(), dto));
    }

    @PutMapping("/helper-status/{isHelper}")
    public Result<AppUserDetailVO> updateHelperStatus(@PathVariable Integer isHelper) {
        return Result.success(appClientUserService.updateHelperStatus(LoginUserContext.getUserId(), isHelper));
    }
}
