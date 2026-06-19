package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.service.AppNotificationService;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

@RestController
@RequestMapping("/app/notifications")
public class AppNotificationController {
    private final AppNotificationService appNotificationService;

    public AppNotificationController(AppNotificationService appNotificationService) {
        this.appNotificationService = appNotificationService;
    }

    @GetMapping
    public Result<PageResult<HelpNotifyRecordVO>> mine(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size
    ) {
        return Result.success(appNotificationService.mine(LoginUserContext.getUserId(), page, size));
    }
}
