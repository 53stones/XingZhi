package org.wl.outdoor.serviceImpl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpNotifyRecordQueryDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.entity.HelpEvent;
import org.wl.outdoor.entity.HelpNotifyRecord;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.mapper.HelpEventMapper;
import org.wl.outdoor.mapper.HelpNotifyRecordMapper;
import org.wl.outdoor.service.HelpNotifyRecordService;
import org.wl.outdoor.vo.HelpNotifyRecordVO;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

@Service
public class HelpNotifyRecordServiceImpl implements HelpNotifyRecordService {
    private final HelpNotifyRecordMapper helpNotifyRecordMapper;
    private final HelpEventMapper helpEventMapper;
    private final AppUserMapper appUserMapper;

    public HelpNotifyRecordServiceImpl(
            HelpNotifyRecordMapper helpNotifyRecordMapper,
            HelpEventMapper helpEventMapper,
            AppUserMapper appUserMapper
    ) {
        this.helpNotifyRecordMapper = helpNotifyRecordMapper;
        this.helpEventMapper = helpEventMapper;
        this.appUserMapper = appUserMapper;
    }

    @Override
    public PageResult<HelpNotifyRecordVO> list(HelpNotifyRecordQueryDTO dto) {
        if (dto == null) {
            dto = new HelpNotifyRecordQueryDTO();
        }

        Page<HelpNotifyRecord> page = new Page<>(dto.getPage(), dto.getSize());

        LambdaQueryWrapper<HelpNotifyRecord> wrapper = new LambdaQueryWrapper<>();

        if (dto.getHelpId() != null) {
            wrapper.eq(HelpNotifyRecord::getHelpId, dto.getHelpId());
        }

        if (dto.getReceiverId() != null) {
            wrapper.eq(HelpNotifyRecord::getReceiverId, dto.getReceiverId());
        }

        if (dto.getEmergencyLevel() != null) {
            wrapper.eq(HelpNotifyRecord::getEmergencyLevel, dto.getEmergencyLevel());
        }

        if (dto.getNeedVibration() != null) {
            wrapper.eq(HelpNotifyRecord::getNeedVibration, dto.getNeedVibration());
        }

        if (dto.getNotifyStatus() != null) {
            wrapper.eq(HelpNotifyRecord::getNotifyStatus, dto.getNotifyStatus());
        }

        if (dto.getStartTime() != null) {
            wrapper.ge(HelpNotifyRecord::getCreateTime, dto.getStartTime());
        }

        if (dto.getEndTime() != null) {
            wrapper.le(HelpNotifyRecord::getCreateTime, dto.getEndTime());
        }

        wrapper.orderByDesc(HelpNotifyRecord::getCreateTime);

        Page<HelpNotifyRecord> result = helpNotifyRecordMapper.selectPage(page, wrapper);

        List<HelpNotifyRecordVO> records = result.getRecords()
                .stream()
                .map(this::toVO)
                .toList();

        return new PageResult<>(result.getTotal(), records);
    }

    private HelpNotifyRecordVO toVO(HelpNotifyRecord record) {
        HelpNotifyRecordVO vo = new HelpNotifyRecordVO();

        vo.setId(record.getId());
        vo.setHelpId(record.getHelpId());
        vo.setEmergencyLevel(record.getEmergencyLevel());
        vo.setEmergencyLevelName(getEmergencyLevelName(record.getEmergencyLevel()));
        vo.setNotifyColor(getNotifyColor(record.getEmergencyLevel()));

        vo.setReceiverId(record.getReceiverId());
        vo.setNeedVibration(record.getNeedVibration());
        vo.setNeedVibrationName(getNeedVibrationName(record.getNeedVibration()));
        vo.setNotifyStatus(record.getNotifyStatus());
        vo.setNotifyStatusName(getNotifyStatusName(record.getNotifyStatus()));
        vo.setCreateTime(record.getCreateTime());

        HelpEvent event = helpEventMapper.selectById(record.getHelpId());
        if (event != null) {
            vo.setHelpType(event.getHelpType());
        }

        AppUser receiver = appUserMapper.selectById(record.getReceiverId());
        if (receiver != null) {
            vo.setReceiverName(getUserDisplayName(receiver));
            vo.setReceiverPhone(receiver.getPhone());
        }

        return vo;
    }

    private String getUserDisplayName(AppUser user) {
        if (user == null) {
            return null;
        }

        if (StringUtils.hasText(user.getNickname())) {
            return user.getNickname();
        }

        return user.getUsername();
    }

    private String getEmergencyLevelName(Integer level) {
        if (level == null) {
            return "未知";
        }

        return switch (level) {
            case 1 -> "普通求助";
            case 2 -> "紧急求助";
            case 3 -> "高危求助";
            default -> "未知";
        };
    }

    private String getNotifyColor(Integer level) {
        if (level == null) {
            return "GRAY";
        }

        return switch (level) {
            case 1 -> "BLUE";
            case 2 -> "ORANGE";
            case 3 -> "RED";
            default -> "GRAY";
        };
    }

    private String getNeedVibrationName(Integer needVibration) {
        if (needVibration == null) {
            return "未知";
        }

        return switch (needVibration) {
            case 0 -> "不振动";
            case 1 -> "振动";
            default -> "未知";
        };
    }

    private String getNotifyStatusName(Integer status) {
        if (status == null) {
            return "未知";
        }

        return switch (status) {
            case 0 -> "待发送";
            case 1 -> "已发送";
            case 2 -> "发送失败";
            default -> "未知";
        };
    }
}
