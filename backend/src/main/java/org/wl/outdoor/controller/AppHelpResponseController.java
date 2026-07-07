package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.*;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.service.AppHelpResponseService;
import org.wl.outdoor.vo.HelpResponseVO;

@RestController
@RequestMapping("/app/help-responses")
public class AppHelpResponseController {
    private final AppHelpResponseService appHelpResponseService;

    public AppHelpResponseController(AppHelpResponseService appHelpResponseService) {
        this.appHelpResponseService = appHelpResponseService;
    }

    @PostMapping("/help-events/{helpId}")
    public Result<HelpResponseVO> respond(@PathVariable Long helpId) {
        return Result.success(appHelpResponseService.respond(LoginUserContext.getUserId(), helpId));
    }

    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable Long id) {
        appHelpResponseService.cancel(LoginUserContext.getUserId(), id);
        return Result.success();
    }

    @GetMapping("/mine")
    public Result<PageResult<HelpResponseVO>> mine(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(appHelpResponseService.mine(LoginUserContext.getUserId(), page, size));
    }
}
