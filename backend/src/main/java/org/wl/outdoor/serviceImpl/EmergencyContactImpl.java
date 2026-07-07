package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.entity.EmergencyContact;
import org.wl.outdoor.mapper.EmergencyContactMapper;
import org.wl.outdoor.service.EmergencyContactService;

import java.util.List;

@Service
public class EmergencyContactImpl implements EmergencyContactService {
    @Autowired
    EmergencyContactMapper emergencyContactMapper;
    public List<EmergencyContact> selectList(Long id) {
        LambdaQueryWrapper<EmergencyContact> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(EmergencyContact::getUserId,id);
        return emergencyContactMapper.selectList(wrapper);
    }
}
