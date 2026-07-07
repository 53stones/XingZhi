package org.wl.outdoor.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class AppUserVO {
    private Long id;

    private String username;

    private String phone;

    private String nickname;

    private String avatar;

    private Integer status;

    private Integer isHelper;

    private LocalDateTime createTime;
}
