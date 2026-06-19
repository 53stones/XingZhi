package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.*;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.dto.AppNearbyHelpQueryDTO;
import org.wl.outdoor.service.AppHelpEventService;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

@RestController
@RequestMapping("/app/help-events")
public class AppHelpEventController {
    private final AppHelpEventService appHelpEventService;

    public AppHelpEventController(AppHelpEventService appHelpEventService) {
        this.appHelpEventService = appHelpEventService;
    }

    @PostMapping
    public Result<HelpEventDetailVO> create(@RequestBody AppHelpEventCreateDTO dto) {
        return Result.success(appHelpEventService.create(LoginUserContext.getUserId(), dto));
    }

    @GetMapping("/mine")
    public Result<PageResult<HelpEventVO>> mine(@RequestParam(defaultValue = "1") Integer page, @RequestParam(defaultValue = "10") Integer size) {
        return Result.success(appHelpEventService.mine(LoginUserContext.getUserId(), page, size));
    }

    @GetMapping("/nearby")
    public Result<PageResult<HelpEventVO>> nearby(AppNearbyHelpQueryDTO dto) {
        return Result.success(appHelpEventService.nearby(LoginUserContext.getUserId(), dto));
    }

    @GetMapping("/latest")
    public Result<HelpEventDetailVO> latest() {
        return Result.success(appHelpEventService.latest(LoginUserContext.getUserId()));
    }

    @GetMapping("/{id}")
    public Result<HelpEventDetailVO> detail(@PathVariable Long id) {
        return Result.success(appHelpEventService.detail(LoginUserContext.getUserId(), id));
    }

    @PutMapping("/{id}/cancel")
    public Result<Void> cancel(@PathVariable Long id) {
        appHelpEventService.cancel(LoginUserContext.getUserId(), id);
        return Result.success();
    }
}
