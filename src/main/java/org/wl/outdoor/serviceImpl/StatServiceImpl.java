package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;
import org.wl.outdoor.entity.*;
import org.wl.outdoor.mapper.*;
import org.wl.outdoor.service.StatService;
import org.wl.outdoor.vo.StatOverviewVO;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Service
public class StatServiceImpl implements StatService {
    private final AppUserMapper appUserMapper;
    private final SysAdminMapper sysAdminMapper;
    private final HelpEventMapper helpEventMapper;
    private final HelpResponseMapper helpResponseMapper;
    private final HelpNotifyRecordMapper helpNotifyRecordMapper;

    public StatServiceImpl(
            AppUserMapper appUserMapper,
            SysAdminMapper sysAdminMapper,
            HelpEventMapper helpEventMapper,
            HelpResponseMapper helpResponseMapper,
            HelpNotifyRecordMapper helpNotifyRecordMapper
    ) {
        this.appUserMapper = appUserMapper;
        this.sysAdminMapper = sysAdminMapper;
        this.helpEventMapper = helpEventMapper;
        this.helpResponseMapper = helpResponseMapper;
        this.helpNotifyRecordMapper = helpNotifyRecordMapper;
    }

    @Override
    public StatOverviewVO overview() {
        StatOverviewVO vo = new StatOverviewVO();

        Long userCount = appUserMapper.selectCount(new LambdaQueryWrapper<AppUser>());
        Long adminCount = sysAdminMapper.selectCount(new LambdaQueryWrapper<SysAdmin>());
        Long helpEventCount = helpEventMapper.selectCount(new LambdaQueryWrapper<HelpEvent>());

        Long quickHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getHelpMode, 1)
        );

        Long customHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getHelpMode, 2)
        );

        Long pendingHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getStatus, 0)
        );

        Long respondedHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getStatus, 1)
        );

        Long processingHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getStatus, 2)
        );

        Long finishedHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getStatus, 3)
        );

        Long canceledHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getStatus, 4)
        );

        Long dangerHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getEmergencyLevel, 3)
        );

        Long responseRecordCount = helpResponseMapper.selectCount(
                new LambdaQueryWrapper<HelpResponse>()
        );

        Long notifyRecordCount = helpNotifyRecordMapper.selectCount(
                new LambdaQueryWrapper<HelpNotifyRecord>()
        );

        LocalDateTime todayStart = LocalDate.now().atStartOfDay();
        LocalDateTime tomorrowStart = LocalDate.now().plusDays(1).atStartOfDay();

        Long todayHelpCount = helpEventMapper.selectCount(
                new LambdaQueryWrapper<HelpEvent>()
                        .ge(HelpEvent::getCreateTime, todayStart)
                        .lt(HelpEvent::getCreateTime, tomorrowStart)
        );

        vo.setUserCount(userCount);
        vo.setAdminCount(adminCount);
        vo.setHelpEventCount(helpEventCount);
        vo.setQuickHelpCount(quickHelpCount);
        vo.setCustomHelpCount(customHelpCount);
        vo.setPendingHelpCount(pendingHelpCount);
        vo.setRespondedHelpCount(respondedHelpCount);
        vo.setProcessingHelpCount(processingHelpCount);
        vo.setFinishedHelpCount(finishedHelpCount);
        vo.setCanceledHelpCount(canceledHelpCount);
        vo.setDangerHelpCount(dangerHelpCount);
        vo.setResponseRecordCount(responseRecordCount);
        vo.setNotifyRecordCount(notifyRecordCount);
        vo.setTodayHelpCount(todayHelpCount);

        double responseRate = helpEventCount == null || helpEventCount == 0
                ? 0.0
                : (respondedHelpCount + processingHelpCount + finishedHelpCount) * 1.0 / helpEventCount;

        vo.setResponseRate(responseRate);

        return vo;
    }
}
