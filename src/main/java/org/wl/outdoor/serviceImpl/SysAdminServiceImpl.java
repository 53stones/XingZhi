package org.wl.outdoor.serviceImpl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.wl.outdoor.common.PageResult;
import org.wl.outdoor.dto.AdminCreateDTO;
import org.wl.outdoor.dto.AdminQueryDTO;
import org.wl.outdoor.dto.AdminResetPasswordDTO;
import org.wl.outdoor.entity.SysAdmin;
import org.wl.outdoor.mapper.SysAdminMapper;
import org.wl.outdoor.service.SysAdminService;
import org.wl.outdoor.util.PasswordUtil;
import org.wl.outdoor.vo.SysAdminVO;

import java.util.List;

@Service
public class SysAdminServiceImpl implements SysAdminService {

    private final SysAdminMapper sysAdminMapper;

    public SysAdminServiceImpl(SysAdminMapper sysAdminMapper) {
        this.sysAdminMapper = sysAdminMapper;
    }

    @Override
    public PageResult<SysAdminVO> list(AdminQueryDTO dto) {
        if (dto == null) {
            dto = new AdminQueryDTO();
        }

        Page<SysAdmin> page = new Page<>(dto.getPage(), dto.getSize());

        LambdaQueryWrapper<SysAdmin> wrapper = new LambdaQueryWrapper<>();

        String keyword = dto.getKeyword();
        Integer status = dto.getStatus();

        if (StringUtils.hasText(keyword)) {
            wrapper.and(w -> w
                    .like(SysAdmin::getUsername, keyword)
                    .or()
                    .like(SysAdmin::getNickname, keyword)
            );
        }

        if (status != null) {
            wrapper.eq(SysAdmin::getStatus, status);
        }

        wrapper.orderByDesc(SysAdmin::getCreateTime);

        Page<SysAdmin> result = sysAdminMapper.selectPage(page, wrapper);

        List<SysAdminVO> records = result.getRecords()
                .stream()
                .map(this::toVO)
                .toList();

        return new PageResult<>(result.getTotal(), records);
    }

    @Override
    public void create(AdminCreateDTO dto, Long currentAdminId, String currentRole) {
        checkSuperAdmin(currentRole);

        if (dto == null) {
            throw new RuntimeException("请求参数不能为空");
        }

        if (!StringUtils.hasText(dto.getUsername())) {
            throw new RuntimeException("管理员账号不能为空");
        }

        if (!StringUtils.hasText(dto.getPassword())) {
            throw new RuntimeException("管理员密码不能为空");
        }

        SysAdmin exist = sysAdminMapper.selectOne(
                new LambdaQueryWrapper<SysAdmin>()
                        .eq(SysAdmin::getUsername, dto.getUsername())
        );

        if (exist != null) {
            throw new RuntimeException("管理员账号已存在");
        }

        SysAdmin admin = new SysAdmin();
        admin.setUsername(dto.getUsername());
        admin.setPassword(PasswordUtil.encode(dto.getPassword()));
        admin.setNickname(dto.getNickname());

        // 关键规则：接口新增的管理员只能是普通管理员
        admin.setRole("ADMIN");

        admin.setStatus(1);

        sysAdminMapper.insert(admin);
    }

    @Override
    public void enable(Long id, Long currentAdminId, String currentRole) {
        checkSuperAdmin(currentRole);
        updateStatus(id, 1, currentAdminId);
    }

    @Override
    public void disable(Long id, Long currentAdminId, String currentRole) {
        checkSuperAdmin(currentRole);

        if (id.equals(currentAdminId)) {
            throw new RuntimeException("不能禁用当前登录管理员");
        }

        updateStatus(id, 0, currentAdminId);
    }

    @Override
    public void resetPassword(Long id, AdminResetPasswordDTO dto, Long currentAdminId, String currentRole) {
        checkSuperAdmin(currentRole);

        if (dto == null || !StringUtils.hasText(dto.getNewPassword())) {
            throw new RuntimeException("新密码不能为空");
        }

        SysAdmin admin = sysAdminMapper.selectById(id);

        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }

        if ("SUPER_ADMIN".equals(admin.getRole()) && !id.equals(currentAdminId)) {
            throw new RuntimeException("不能重置其他超级管理员密码");
        }

        SysAdmin update = new SysAdmin();
        update.setId(id);
        update.setPassword(PasswordUtil.encode(dto.getNewPassword()));

        sysAdminMapper.updateById(update);
    }

    private void updateStatus(Long id, Integer status, Long currentAdminId) {
        SysAdmin admin = sysAdminMapper.selectById(id);

        if (admin == null) {
            throw new RuntimeException("管理员不存在");
        }

        if ("SUPER_ADMIN".equals(admin.getRole()) && !id.equals(currentAdminId)) {
            throw new RuntimeException("不能修改其他超级管理员状态");
        }

        SysAdmin update = new SysAdmin();
        update.setId(id);
        update.setStatus(status);

        sysAdminMapper.updateById(update);
    }

    private void checkSuperAdmin(String currentRole) {
        if (!"SUPER_ADMIN".equals(currentRole)) {
            throw new RuntimeException("只有超级管理员可以执行该操作");
        }
    }

    private SysAdminVO toVO(SysAdmin admin) {
        SysAdminVO vo = new SysAdminVO();
        vo.setId(admin.getId());
        vo.setUsername(admin.getUsername());
        vo.setNickname(admin.getNickname());
        vo.setRole(admin.getRole());
        vo.setStatus(admin.getStatus());
        vo.setCreateTime(admin.getCreateTime());
        return vo;
    }
}