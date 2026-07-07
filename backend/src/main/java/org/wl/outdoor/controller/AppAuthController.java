package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AppUserLoginDTO;
import org.wl.outdoor.dto.AppUserRegisterDTO;
import org.wl.outdoor.service.AppAuthService;
import org.wl.outdoor.vo.AppUserLoginVO;

@RestController
@RequestMapping("/app/auth")
public class AppAuthController {
    private final AppAuthService appAuthService;

    public AppAuthController(AppAuthService appAuthService) {
        this.appAuthService = appAuthService;
    }

    @PostMapping("/register")
    public Result<AppUserLoginVO> register(@RequestBody AppUserRegisterDTO dto) {
        return Result.success(appAuthService.register(dto));
    }

    @PostMapping("/login")
    public Result<AppUserLoginVO> login(@RequestBody AppUserLoginDTO dto) {
        return Result.success(appAuthService.login(dto));
    }
}
