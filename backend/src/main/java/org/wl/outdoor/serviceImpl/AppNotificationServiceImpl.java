package org.wl.outdoor.serviceImpl;

import org.springframework.stereotype.Service;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpNotifyRecordQueryDTO;
import org.wl.outdoor.service.AppNotificationService;
import org.wl.outdoor.service.HelpNotifyRecordService;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

@Service
public class AppNotificationServiceImpl implements AppNotificationService {
    private final HelpNotifyRecordService helpNotifyRecordService;

    public AppNotificationServiceImpl(HelpNotifyRecordService helpNotifyRecordService) {
        this.helpNotifyRecordService = helpNotifyRecordService;
    }

    @Override
    public PageResult<HelpNotifyRecordVO> mine(Long userId, Integer page, Integer size) {
        HelpNotifyRecordQueryDTO dto = new HelpNotifyRecordQueryDTO();
        dto.setReceiverId(userId);
        dto.setPage(page == null ? 1 : page);
        dto.setSize(size == null ? 10 : size);
        return helpNotifyRecordService.list(dto);
    }
}
