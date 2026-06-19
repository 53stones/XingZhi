package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

public interface AppNotificationService {
    PageResult<HelpNotifyRecordVO> mine(Long userId, Integer page, Integer size);
}
