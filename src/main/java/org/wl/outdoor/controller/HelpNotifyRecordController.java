package org.wl.outdoor.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.common.Result;
import org.wl.outdoor.dto.HelpNotifyRecordQueryDTO;
import org.wl.outdoor.service.HelpNotifyRecordService;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

@RestController
@RequestMapping("/admin/help-notify-records")
public class HelpNotifyRecordController {
    private final HelpNotifyRecordService helpNotifyRecordService;

    public HelpNotifyRecordController(HelpNotifyRecordService helpNotifyRecordService) {
        this.helpNotifyRecordService = helpNotifyRecordService;
    }

    @GetMapping
    public Result<PageResult<HelpNotifyRecordVO>> list(HelpNotifyRecordQueryDTO dto) {
        return Result.success(helpNotifyRecordService.list(dto));
    }
}
