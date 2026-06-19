package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpEventQueryDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.entity.HelpEvent;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.mapper.HelpEventMapper;
import org.wl.outdoor.service.HelpEventService;
import org.wl.outdoor.vo.HelpEventDetailVO;
import org.wl.outdoor.vo.HelpEventVO;

import java.util.List;

@Service
public class HelpEventServiceImpl implements HelpEventService {
    private final HelpEventMapper helpEventMapper;
    private final AppUserMapper appUserMapper;

    public HelpEventServiceImpl(
            HelpEventMapper helpEventMapper,
            AppUserMapper appUserMapper
    ) {
        this.helpEventMapper = helpEventMapper;
        this.appUserMapper = appUserMapper;
    }

    @Override
    public PageResult<HelpEventVO> list(HelpEventQueryDTO dto) {
        if (dto == null) {
            dto = new HelpEventQueryDTO();
        }

        Page<HelpEvent> page = new Page<>(dto.getPage(), dto.getSize());

        LambdaQueryWrapper<HelpEvent> wrapper = new LambdaQueryWrapper<>();

        String keyword = dto.getKeyword();

        if (dto.getHelpMode() != null) {
            wrapper.eq(HelpEvent::getHelpMode, dto.getHelpMode());
        }

        if (dto.getEmergencyLevel() != null) {
            wrapper.eq(HelpEvent::getEmergencyLevel, dto.getEmergencyLevel());
        }

        if (dto.getStatus() != null) {
            wrapper.eq(HelpEvent::getStatus, dto.getStatus());
        }

        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(HelpEvent::getHelpType, keyword)
                    .or()
                    .like(HelpEvent::getDescription, keyword)
            );
        }

        if (dto.getStartTime() != null) {
            wrapper.ge(HelpEvent::getCreateTime, dto.getStartTime());
        }

        if (dto.getEndTime() != null) {
            wrapper.le(HelpEvent::getCreateTime, dto.getEndTime());
        }

        wrapper.orderByDesc(HelpEvent::getCreateTime);

        Page<HelpEvent> result = helpEventMapper.selectPage(page, wrapper);

        List<HelpEventVO> records = result.getRecords()
                .stream()
                .map(this::toVO)
                .toList();

        return new PageResult<>(result.getTotal(), records);
    }

    @Override
    public HelpEventDetailVO detail(Long id) {
        HelpEvent event = helpEventMapper.selectById(id);

        if (event == null) {
            throw new RuntimeException("求助事件不存在");
        }

        return toDetailVO(event);
    }

    private HelpEventVO toVO(HelpEvent event) {
        HelpEventVO vo = new HelpEventVO();

        vo.setId(event.getId());
        vo.setHelpMode(event.getHelpMode());
        vo.setHelpModeName(getHelpModeName(event.getHelpMode()));
        vo.setHelpType(event.getHelpType());
        vo.setEmergencyLevel(event.getEmergencyLevel());
        vo.setEmergencyLevelName(getEmergencyLevelName(event.getEmergencyLevel()));
        vo.setNotifyColor(getNotifyColor(event.getEmergencyLevel()));

        vo.setRequesterId(event.getRequesterId());
        vo.setRequesterName(getUserName(event.getRequesterId()));

        vo.setResponderId(event.getResponderId());
        vo.setResponderName(getUserName(event.getResponderId()));

        vo.setStatus(event.getStatus());
        vo.setStatusName(getStatusName(event.getStatus()));
        vo.setCreateTime(event.getCreateTime());

        return vo;
    }

    private HelpEventDetailVO toDetailVO(HelpEvent event) {
        HelpEventDetailVO vo = new HelpEventDetailVO();

        vo.setId(event.getId());
        vo.setHelpMode(event.getHelpMode());
        vo.setHelpModeName(getHelpModeName(event.getHelpMode()));
        vo.setHelpType(event.getHelpType());
        vo.setEmergencyLevel(event.getEmergencyLevel());
        vo.setEmergencyLevelName(getEmergencyLevelName(event.getEmergencyLevel()));
        vo.setNotifyColor(getNotifyColor(event.getEmergencyLevel()));

        vo.setDescription(event.getDescription());
        vo.setLatitude(event.getLatitude());
        vo.setLongitude(event.getLongitude());
        vo.setRadius(event.getRadius());
        vo.setImageUrls(event.getImageUrls());

        vo.setStatus(event.getStatus());
        vo.setStatusName(getStatusName(event.getStatus()));

        vo.setRequesterId(event.getRequesterId());
        AppUser requester = getUser(event.getRequesterId());
        if (requester != null) {
            vo.setRequesterName(requester.getNickname());
            vo.setRequesterPhone(requester.getPhone());
        }

        vo.setResponderId(event.getResponderId());
        AppUser responder = getUser(event.getResponderId());
        if (responder != null) {
            vo.setResponderName(responder.getNickname());
            vo.setResponderPhone(responder.getPhone());
        }

        vo.setCreateTime(event.getCreateTime());
        vo.setUpdateTime(event.getUpdateTime());

        return vo;
    }

    private AppUser getUser(Long userId) {
        if (userId == null) {
            return null;
        }
        return appUserMapper.selectById(userId);
    }

    private String getUserName(Long userId) {
        AppUser user = getUser(userId);

        if (user == null) {
            return null;
        }

        if (StringUtils.hasText(user.getNickname())) {
            return user.getNickname();
        }

        return user.getUsername();
    }

    private String getHelpModeName(Integer helpMode) {
        if (helpMode == null) {
            return "未知";
        }

        return switch (helpMode) {
            case 1 -> "一键求助";
            case 2 -> "自定义求助";
            default -> "未知";
        };
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

    private String getStatusName(Integer status) {
        if (status == null) {
            return "未知";
        }

        return switch (status) {
            case 0 -> "待响应";
            case 1 -> "已响应";
            case 2 -> "进行中";
            case 3 -> "已完成";
            case 4 -> "已取消";
            default -> "未知";
        };
    }
}
