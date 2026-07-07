package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.dto.AdminLoginDTO;
import org.wl.outdoor.entity.SysAdmin;
import org.wl.outdoor.mapper.SysAdminMapper;
import org.wl.outdoor.service.AdminLoginService;
import org.wl.outdoor.util.JwtUtil;
import org.wl.outdoor.util.PasswordUtil;
import org.wl.outdoor.vo.AdminLoginVO;

@Service
public class AdminLoginServiceImpl implements AdminLoginService {
    private final SysAdminMapper sysAdminMapper;
    public AdminLoginServiceImpl(SysAdminMapper sysAdminMapper) {
        this.sysAdminMapper = sysAdminMapper;
    }
    @Override
    public AdminLoginVO login(AdminLoginDTO dto) {
        if (!StringUtils.hasText(dto.getUsername())) {
            throw new RuntimeException("管理员账号不能为空");
        }

        if (!StringUtils.hasText(dto.getPassword())) {
            throw new RuntimeException("管理员密码不能为空");
        }


        SysAdmin admin = sysAdminMapper.selectOne(
                new LambdaQueryWrapper<SysAdmin>()
                        .eq(SysAdmin::getUsername, dto.getUsername())
        );

        if (admin == null) {
            throw new RuntimeException("管理员账号不存在");
        }

        if (admin.getStatus() == null || admin.getStatus() == 0) {
            throw new RuntimeException("管理员账号已被禁用");
        }
        //Bcrypt密码验证
        if (!PasswordUtil.matches(dto.getPassword(), admin.getPassword())) {
            throw new RuntimeException("密码错误");
        }
        //自动将普通密码加密
        if (!PasswordUtil.isBcrypt(admin.getPassword())) {
            SysAdmin update = new SysAdmin();
            update.setId(admin.getId());
            update.setPassword(PasswordUtil.encode(dto.getPassword()));
            sysAdminMapper.updateById(update);
        }

        String token = JwtUtil.createToken(
                admin.getId(),
                admin.getUsername(),
                admin.getRole()
        );

        AdminLoginVO vo = new AdminLoginVO();
        vo.setId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setNickname(admin.getNickname());
        vo.setRole(admin.getRole());
        vo.setToken(token);

        return vo;
    }
}