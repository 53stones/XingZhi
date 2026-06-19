package org.wl.outdoor.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("app_user")
public class AppUser {
    private Long id;

    private String username;

    private String password;

    private String phone;

    private String nickname;

    private String avatar;

    private Integer status;

    private Integer isHelper;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
