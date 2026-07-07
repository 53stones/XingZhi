package org.wl.outdoor.serviceImpl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.AppHelpEventCreateDTO;
import org.wl.outdoor.dto.AppNearbyHelpQueryDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.entity.HelpEvent;
import org.wl.outdoor.entity.HelpNotifyRecord;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.mapper.HelpEventMapper;
import org.wl.outdoor.mapper.HelpNotifyRecordMapper;
import org.wl.outdoor.service.AppHelpEventService;
import org.wl.outdoor.service.HelpEventService;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

@Service
public class AppHelpEventServiceImpl implements AppHelpEventService {
    private final HelpEventMapper helpEventMapper;
    private final HelpEventService helpEventService;
    private final AppUserMapper appUserMapper;
    private final HelpNotifyRecordMapper helpNotifyRecordMapper;

    public AppHelpEventServiceImpl(
            HelpEventMapper helpEventMapper,
            HelpEventService helpEventService,
            AppUserMapper appUserMapper,
            HelpNotifyRecordMapper helpNotifyRecordMapper
    ) {
        this.helpEventMapper = helpEventMapper;
        this.helpEventService = helpEventService;
        this.appUserMapper = appUserMapper;
        this.helpNotifyRecordMapper = helpNotifyRecordMapper;
    }

    @Override
    public HelpEventDetailVO create(Long userId, AppHelpEventCreateDTO dto) {
        if (dto == null || dto.getHelpMode() == null || dto.getEmergencyLevel() == null) {
            throw new RuntimeException("求助模式和紧急等级不能为空");
        }
        HelpEvent event = new HelpEvent();
        event.setRequesterId(userId);
        event.setHelpMode(dto.getHelpMode());
        event.setHelpType(dto.getHelpType());
        event.setEmergencyLevel(dto.getEmergencyLevel());
        event.setDescription(dto.getDescription());
        event.setLatitude(dto.getLatitude());
        event.setLongitude(dto.getLongitude());
        event.setRadius(dto.getRadius());
        event.setImageUrls(dto.getImageUrls());
        event.setStatus(0);
        event.setCreateTime(LocalDateTime.now());
        event.setUpdateTime(LocalDateTime.now());
        helpEventMapper.insert(event);
        createNotifyRecords(userId, event);
        return helpEventService.detail(event.getId());
    }

    @Override
    public PageResult<HelpEventVO> mine(Long userId, Integer page, Integer size) {
        Page<HelpEvent> result = helpEventMapper.selectPage(
                new Page<>(page == null ? 1 : page, size == null ? 10 : size),
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getRequesterId, userId)
                        .orderByDesc(HelpEvent::getCreateTime)
        );
        List<HelpEventVO> records = result.getRecords().stream()
                .map(event -> toVO(helpEventService.detail(event.getId())))
                .toList();
        return new PageResult<>(result.getTotal(), records);
    }

    @Override
    public PageResult<HelpEventVO> nearby(Long userId, AppNearbyHelpQueryDTO dto) {
        long page = (dto == null || dto.getPage() == null) ? 1L : dto.getPage().longValue();
        long size = (dto == null || dto.getSize() == null) ? 10L : dto.getSize().longValue();
        LambdaQueryWrapper<HelpEvent> wrapper = new LambdaQueryWrapper<HelpEvent>()
                .ne(HelpEvent::getRequesterId, userId)
                .in(HelpEvent::getStatus, 1, 2);

        if (dto != null && dto.getLatitude() != null && dto.getLongitude() != null) {
            BigDecimal latitude = dto.getLatitude();
            BigDecimal longitude = dto.getLongitude();
            Integer radius = dto.getRadius() == null ? 3 : dto.getRadius();
            wrapper.apply(
                    "6371 * acos(cos(radians({0})) * cos(radians(latitude)) * cos(radians(longitude) - radians({1})) + sin(radians({0})) * sin(radians(latitude))) <= {2}",
                    latitude,
                    longitude,
                    radius
            );
        }

        Page<HelpEvent> result = helpEventMapper.selectPage(
                new Page<>(page, size),
                wrapper.orderByDesc(HelpEvent::getCreateTime)
        );
        List<HelpEventVO> records = result.getRecords().stream()
                .map(event -> toVO(helpEventService.detail(event.getId())))
                .toList();
        return new PageResult<>(result.getTotal(), records);
    }

    @Override
    public HelpEventDetailVO latest(Long userId) {
        HelpEvent event = helpEventMapper.selectOne(
                new LambdaQueryWrapper<HelpEvent>()
                        .eq(HelpEvent::getRequesterId, userId)
                        .orderByDesc(HelpEvent::getCreateTime)
                        .last("limit 1")
        );
        return event == null ? null : helpEventService.detail(event.getId());
    }

    @Override
    public HelpEventDetailVO detail(Long userId, Long id) {
        return helpEventService.detail(id);
    }

    @Override
    public void cancel(Long userId, Long id) {
        HelpEvent event = helpEventMapper.selectById(id);
        if (event == null || !userId.equals(event.getRequesterId())) {
            throw new RuntimeException("求助事件不存在");
        }
        if (event.getStatus() != null && event.getStatus() >= 3) {
            throw new RuntimeException("当前事件不可取消");
        }
        event.setStatus(4);
        event.setUpdateTime(LocalDateTime.now());
        helpEventMapper.updateById(event);
    }

    private HelpEventVO toVO(HelpEventDetailVO detail) {
        HelpEventVO vo = new HelpEventVO();
        vo.setId(detail.getId());
        vo.setHelpMode(detail.getHelpMode());
        vo.setHelpModeName(detail.getHelpModeName());
        vo.setHelpType(detail.getHelpType());
        vo.setEmergencyLevel(detail.getEmergencyLevel());
        vo.setEmergencyLevelName(detail.getEmergencyLevelName());
        vo.setNotifyColor(detail.getNotifyColor());
        vo.setRequesterId(detail.getRequesterId());
        vo.setRequesterName(detail.getRequesterName());
        vo.setResponderId(detail.getResponderId());
        vo.setResponderName(detail.getResponderName());
        vo.setStatus(detail.getStatus());
        vo.setStatusName(detail.getStatusName());
        vo.setLatitude(detail.getLatitude());
        vo.setLongitude(detail.getLongitude());
        vo.setCreateTime(detail.getCreateTime());
        return vo;
    }

    private void createNotifyRecords(Long requesterId, HelpEvent event) {
        List<AppUser> helpers = appUserMapper.selectList(
                new LambdaQueryWrapper<AppUser>()
                        .eq(AppUser::getStatus, 1)
                        .eq(AppUser::getIsHelper, 1)
                        .ne(AppUser::getId, requesterId)
        );
        for (AppUser helper : helpers) {
            HelpNotifyRecord record = new HelpNotifyRecord();
            record.setHelpId(event.getId());
            record.setReceiverId(helper.getId());
            record.setEmergencyLevel(event.getEmergencyLevel());
            record.setNeedVibration(event.getEmergencyLevel() != null && event.getEmergencyLevel() >= 2 ? 1 : 0);
            record.setNotifyStatus(1);
            record.setCreateTime(LocalDateTime.now());
            helpNotifyRecordMapper.insert(record);
        }
    }
}
