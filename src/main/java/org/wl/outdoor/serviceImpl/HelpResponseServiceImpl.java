package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.HelpResponseQueryDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.entity.HelpEvent;
import org.wl.outdoor.entity.HelpResponse;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.mapper.HelpEventMapper;
import org.wl.outdoor.mapper.HelpResponseMapper;
import org.wl.outdoor.service.HelpResponseService;
import org.wl.outdoor.vo.HelpResponseVO;

import java.util.List;

@Service
public class HelpResponseServiceImpl implements HelpResponseService {
    private final HelpResponseMapper helpResponseMapper;
    private final HelpEventMapper helpEventMapper;
    private final AppUserMapper appUserMapper;

    public HelpResponseServiceImpl(
            HelpResponseMapper helpResponseMapper,
            HelpEventMapper helpEventMapper,
            AppUserMapper appUserMapper
    ) {
        this.helpResponseMapper = helpResponseMapper;
        this.helpEventMapper = helpEventMapper;
        this.appUserMapper = appUserMapper;
    }

    @Override
    public PageResult<HelpResponseVO> list(HelpResponseQueryDTO dto) {
        if (dto == null) {
            dto = new HelpResponseQueryDTO();
        }

        Page<HelpResponse> page = new Page<>(dto.getPage(), dto.getSize());

        LambdaQueryWrapper<HelpResponse> wrapper = new LambdaQueryWrapper<>();

        if (dto.getHelpId() != null) {
            wrapper.eq(HelpResponse::getHelpId, dto.getHelpId());
        }

        if (dto.getResponderId() != null) {
            wrapper.eq(HelpResponse::getResponderId, dto.getResponderId());
        }

        if (dto.getResponseStatus() != null) {
            wrapper.eq(HelpResponse::getResponseStatus, dto.getResponseStatus());
        }

        if (dto.getStartTime() != null) {
            wrapper.ge(HelpResponse::getResponseTime, dto.getStartTime());
        }

        if (dto.getEndTime() != null) {
            wrapper.le(HelpResponse::getResponseTime, dto.getEndTime());
        }

        wrapper.orderByDesc(HelpResponse::getResponseTime);

        Page<HelpResponse> result = helpResponseMapper.selectPage(page, wrapper);

        List<HelpResponseVO> records = result.getRecords()
                .stream()
                .map(this::toVO)
                .toList();

        return new PageResult<>(result.getTotal(), records);
    }

    private HelpResponseVO toVO(HelpResponse response) {
        HelpResponseVO vo = new HelpResponseVO();

        vo.setId(response.getId());
        vo.setHelpId(response.getHelpId());
        vo.setResponderId(response.getResponderId());
        vo.setDistance(response.getDistance());
        vo.setResponseStatus(response.getResponseStatus());
        vo.setResponseStatusName(getResponseStatusName(response.getResponseStatus()));
        vo.setResponseTime(response.getResponseTime());

        HelpEvent event = helpEventMapper.selectById(response.getHelpId());
        if (event != null) {
            vo.setHelpType(event.getHelpType());
            vo.setEmergencyLevel(event.getEmergencyLevel());
            vo.setEmergencyLevelName(getEmergencyLevelName(event.getEmergencyLevel()));
        }

        AppUser responder = appUserMapper.selectById(response.getResponderId());
        if (responder != null) {
            vo.setResponderName(getUserDisplayName(responder));
            vo.setResponderPhone(responder.getPhone());
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

    private String getResponseStatusName(Integer status) {
        if (status == null) {
            return "未知";
        }

        return switch (status) {
            case 1 -> "已响应";
            case 2 -> "取消响应";
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
}
