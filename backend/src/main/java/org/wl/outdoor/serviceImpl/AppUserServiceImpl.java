package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.UserQueryDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.entity.EmergencyContact;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.service.AppUserService;
import org.wl.outdoor.vo.AppUserDetailVO;
import org.wl.outdoor.vo.AppUserVO;

import java.util.List;

@Service
public class AppUserServiceImpl implements AppUserService {
    private final AppUserMapper appUserMapper;

    public AppUserServiceImpl(AppUserMapper appUserMapper) {
        this.appUserMapper = appUserMapper;
    }
    @Override
    public PageResult<AppUserVO> list(UserQueryDTO dto) {
        if (dto == null) {
            dto = new UserQueryDTO();
        }

        Page<AppUser> page = new Page<>(dto.getPage(), dto.getSize());

        LambdaQueryWrapper<AppUser> wrapper = new LambdaQueryWrapper<>();

        String keyword = dto.getKeyword();
        Integer status = dto.getStatus();

        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(AppUser::getUsername, keyword)
                    .or()
                    .like(AppUser::getNickname, keyword)
                    .or()
                    .like(AppUser::getPhone, keyword)
            );
        }

        if (status != null) {
            wrapper.eq(AppUser::getStatus, status);
        }

        wrapper.orderByDesc(AppUser::getCreateTime);

        Page<AppUser> result = appUserMapper.selectPage(page, wrapper);

        List<AppUserVO> records = result.getRecords()
                .stream()
                .map(this::toVO)
                .toList();

        return new PageResult<>(result.getTotal(), records);
    }

    @Override
    public AppUserDetailVO detail(Long id) {
        AppUser user = appUserMapper.selectById(id);

        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        return toDetailVO(user);
    }

    @Override
    public void enable(Long id) {
        updateStatus(id, 1);
    }

    @Override
    public void disable(Long id) {
        updateStatus(id, 0);
    }

    private void updateStatus(Long id, Integer status) {
        AppUser user = appUserMapper.selectById(id);

        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        AppUser update = new AppUser();
        update.setId(id);
        update.setStatus(status);

        appUserMapper.updateById(update);
    }

    private AppUserVO toVO(AppUser user) {
        AppUserVO vo = new AppUserVO();

        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setPhone(user.getPhone());
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        vo.setStatus(user.getStatus());
        vo.setIsHelper(user.getIsHelper());
        vo.setCreateTime(user.getCreateTime());

        return vo;
    }

    private AppUserDetailVO toDetailVO(AppUser user) {
        AppUserDetailVO vo = new AppUserDetailVO();

        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setPhone(user.getPhone());
        vo.setNickname(user.getNickname());
        vo.setAvatar(user.getAvatar());
        vo.setStatus(user.getStatus());
        vo.setIsHelper(user.getIsHelper());
        vo.setCreateTime(user.getCreateTime());
        vo.setUpdateTime(user.getUpdateTime());

        return vo;
    }

}
