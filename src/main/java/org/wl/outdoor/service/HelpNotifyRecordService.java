package org.wl.outdoor.service;

import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpNotifyRecordQueryDTO;
import org.wl.outdoor.entity.HelpNotifyRecord;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

public interface HelpNotifyRecordService {
    PageResult<HelpNotifyRecordVO> list(HelpNotifyRecordQueryDTO dto);
}
