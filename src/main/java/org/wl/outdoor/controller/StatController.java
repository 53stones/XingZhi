package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.service.StatService;
import org.wl.outdoor.vo.StatOverviewVO;

@RestController
@RequestMapping("/admin/stat")
public class StatController {
    private final StatService statService;

    public StatController(StatService statService) {
        this.statService = statService;
    }

    @GetMapping("/overview")
    public Result<StatOverviewVO> overview() {
        return Result.success(statService.overview());
    }
}
