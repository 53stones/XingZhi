package org.wl.outdoor.serviceImpl;

import org.springframework.stereotype.Service;
import org.wl.outdoor.dto.AppUserProfileUpdateDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.service.AppClientUserService;
import org.wl.outdoor.vo.AppUserDetailVO;

import java.time.LocalDateTime;

@Service
public class AppClientUserServiceImpl implements AppClientUserService {
    private final AppUserMapper appUserMapper;

    public AppClientUserServiceImpl(AppUserMapper appUserMapper) {
        this.appUserMapper = appUserMapper;
    }

    @Override
    public AppUserDetailVO profile(Long userId) {
        return toVO(requireUser(userId));
    }

    @Override
    public AppUserDetailVO updateProfile(Long userId, AppUserProfileUpdateDTO dto) {
        AppUser user = requireUser(userId);
        user.setNickname(dto.getNickname());
        user.setPhone(dto.getPhone());
        user.setAvatar(dto.getAvatar());
        user.setUpdateTime(LocalDateTime.now());
        appUserMapper.updateById(user);
        return toVO(user);
    }

    @Override
    public AppUserDetailVO updateHelperStatus(Long userId, Integer isHelper) {
        if (isHelper == null || (isHelper != 0 && isHelper != 1)) {
            throw new RuntimeException("接收求助状态不合法");
        }
        AppUser user = requireUser(userId);
        user.setIsHelper(isHelper);
        user.setUpdateTime(LocalDateTime.now());
        appUserMapper.updateById(user);
        return toVO(user);
    }

    private AppUser requireUser(Long userId) {
        AppUser user = appUserMapper.selectById(userId);
        if (user == null) throw new RuntimeException("用户不存在");
        return user;
    }

    private AppUserDetailVO toVO(AppUser user) {
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
