package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.HelpResponseQueryDTO;
import org.wl.outdoor.service.HelpResponseService;
import org.wl.outdoor.vo.HelpResponseVO;

@RestController
@RequestMapping("/admin/help-responses")
public class HelpResponseController {
    private final HelpResponseService helpResponseService;

    public HelpResponseController(HelpResponseService helpResponseService) {
        this.helpResponseService = helpResponseService;
    }

    @GetMapping
    public Result<PageResult<HelpResponseVO>> list(HelpResponseQueryDTO dto) {
        return Result.success(helpResponseService.list(dto));
    }
}
