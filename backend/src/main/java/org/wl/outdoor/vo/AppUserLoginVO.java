package org.wl.outdoor.vo;

import lombok.Data;

@Data
public class AppUserLoginVO {
    private Long id;
    private String username;
    private String nickname;
    private String phone;
    private String avatar;
    private Integer isHelper;
    private String token;
}
