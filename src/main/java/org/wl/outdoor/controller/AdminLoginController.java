package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AdminLoginDTO;
import org.wl.outdoor.service.AdminLoginService;
import org.wl.outdoor.vo.AdminLoginVO;

@RestController
@RequestMapping("/admin")
public class AdminLoginController {
    private final AdminLoginService adminLoginService;

    public AdminLoginController(AdminLoginService adminAuthService) {
        this.adminLoginService = adminAuthService;
    }

    @PostMapping("/login")
    public Result<AdminLoginVO> login(@RequestBody AdminLoginDTO dto) {
        return Result.success(adminLoginService.login(dto));
    }
}
