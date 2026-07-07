package org.wl.outdoor.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.HelpEventQueryDTO;
import org.wl.outdoor.service.HelpEventService;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

@RestController
@RequestMapping("/admin/help-events")
public class HelpEventController {
    private final HelpEventService helpEventService;

    public HelpEventController(HelpEventService helpEventService) {
        this.helpEventService = helpEventService;
    }

    @GetMapping
    public Result<PageResult<HelpEventVO>> list(HelpEventQueryDTO dto) {
        return Result.success(helpEventService.list(dto));
    }

    @GetMapping("/{id}")
    public Result<HelpEventDetailVO> detail(@PathVariable Long id) {
        return Result.success(helpEventService.detail(id));
    }
}
