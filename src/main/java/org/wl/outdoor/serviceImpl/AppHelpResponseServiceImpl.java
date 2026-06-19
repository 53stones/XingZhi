package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.entity.HelpEvent;
import org.wl.outdoor.entity.HelpResponse;
import org.wl.outdoor.mapper.HelpEventMapper;
import org.wl.outdoor.mapper.HelpResponseMapper;
import org.wl.outdoor.service.AppHelpResponseService;
import org.wl.outdoor.service.HelpResponseService;
import org.wl.outdoor.vo.HelpResponseVO;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class AppHelpResponseServiceImpl implements AppHelpResponseService {
    private final HelpResponseMapper helpResponseMapper;
    private final HelpEventMapper helpEventMapper;
    private final HelpResponseService helpResponseService;

    public AppHelpResponseServiceImpl(
            HelpResponseMapper helpResponseMapper,
            HelpEventMapper helpEventMapper,
            HelpResponseService helpResponseService
    ) {
        this.helpResponseMapper = helpResponseMapper;
        this.helpEventMapper = helpEventMapper;
        this.helpResponseService = helpResponseService;
    }

    @Override
    public HelpResponseVO respond(Long userId, Long helpId) {
        HelpEvent event = helpEventMapper.selectById(helpId);
        if (event == null || event.getStatus() == null || event.getStatus() != 0) {
            throw new RuntimeException("当前事件不可响应");
        }
        HelpResponse existing = helpResponseMapper.selectOne(
                new LambdaQueryWrapper<HelpResponse>()
                        .eq(HelpResponse::getHelpId, helpId)
                        .eq(HelpResponse::getResponderId, userId)
                        .eq(HelpResponse::getResponseStatus, 1)
        );
        if (existing != null) {
            throw new RuntimeException("你已响应该事件");
        }
        HelpResponse response = new HelpResponse();
        response.setHelpId(helpId);
        response.setResponderId(userId);
        response.setResponseStatus(1);
        response.setResponseTime(LocalDateTime.now());
        helpResponseMapper.insert(response);

        event.setResponderId(userId);
        event.setStatus(1);
        event.setUpdateTime(LocalDateTime.now());
        helpEventMapper.updateById(event);

        return mine(userId, 1, 1).getRecords().stream()
                .filter(item -> helpId.equals(item.getHelpId()))
                .findFirst()
                .orElseThrow(() -> new RuntimeException("响应成功但记录读取失败"));
    }

    @Override
    public void cancel(Long userId, Long responseId) {
        HelpResponse response = helpResponseMapper.selectById(responseId);
        if (response == null || !userId.equals(response.getResponderId())) {
            throw new RuntimeException("响应记录不存在");
        }
        response.setResponseStatus(2);
        helpResponseMapper.updateById(response);

        HelpEvent event = helpEventMapper.selectById(response.getHelpId());
        if (event != null && userId.equals(event.getResponderId()) && event.getStatus() != null && event.getStatus() == 1) {
            event.setResponderId(null);
            event.setStatus(0);
            event.setUpdateTime(LocalDateTime.now());
            helpEventMapper.updateById(event);
        }
    }

    @Override
    public PageResult<HelpResponseVO> mine(Long userId, Integer page, Integer size) {
        org.wl.outdoor.dto.HelpResponseQueryDTO dto = new org.wl.outdoor.dto.HelpResponseQueryDTO();
        dto.setPage(page == null ? 1 : page);
        dto.setSize(size == null ? 10 : size);
        dto.setResponderId(userId);
        return helpResponseService.list(dto);
    }
}
