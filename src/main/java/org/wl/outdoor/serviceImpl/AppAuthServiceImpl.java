package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.dto.AppUserLoginDTO;
import org.wl.outdoor.dto.AppUserRegisterDTO;
import org.wl.outdoor.entity.AppUser;
import org.wl.outdoor.mapper.AppUserMapper;
import org.wl.outdoor.service.AppAuthService;
import org.wl.outdoor.util.JwtUtil;
import org.wl.outdoor.util.PasswordUtil;
import org.wl.outdoor.vo.AppUserLoginVO;

import java.time.LocalDateTime;

@Service
public class AppAuthServiceImpl implements AppAuthService {
    private final AppUserMapper appUserMapper;

    public AppAuthServiceImpl(AppUserMapper appUserMapper) {
        this.appUserMapper = appUserMapper;
    }

    @Override
    public AppUserLoginVO register(AppUserRegisterDTO dto) {
        if (dto == null || !StringUtils.hasText(dto.getUsername()) || !StringUtils.hasText(dto.getPassword())) {
            throw new RuntimeException("用户名和密码不能为空");
        }
        AppUser existing = appUserMapper.selectOne(new LambdaQueryWrapper<AppUser>().eq(AppUser::getUsername, dto.getUsername()));
        if (existing != null) {
            throw new RuntimeException("用户名已存在");
        }
        AppUser user = new AppUser();
        user.setUsername(dto.getUsername());
        user.setPassword(PasswordUtil.encode(dto.getPassword()));
        user.setPhone(dto.getPhone());
        user.setNickname(dto.getNickname());
        user.setStatus(1);
        user.setIsHelper(1);
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        appUserMapper.insert(user);
        return toLoginVO(user);
    }

    @Override
    public AppUserLoginVO login(AppUserLoginDTO dto) {
        if (dto == null || !StringUtils.hasText(dto.getUsername()) || !StringUtils.hasText(dto.getPassword())) {
            throw new RuntimeException("用户名和密码不能为空");
        }
        AppUser user = appUserMapper.selectOne(new LambdaQueryWrapper<AppUser>().eq(AppUser::getUsername, dto.getUsername()));
        if (user == null || !PasswordUtil.matches(dto.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }
        if (user.getStatus() == null || user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用");
        }
        return toLoginVO(user);
    }

    private AppUserLoginVO toLoginVO(AppUser user) {
        AppUserLoginVO vo = new AppUserLoginVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setPhone(user.getPhone());
        vo.setAvatar(user.getAvatar());
        vo.setIsHelper(user.getIsHelper());
        vo.setToken(JwtUtil.createUserToken(user.getId(), user.getUsername()));
        return vo;
    }
}
