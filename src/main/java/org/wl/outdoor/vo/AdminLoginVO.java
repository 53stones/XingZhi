package org.wl.outdoor.vo;

import lombok.Data;

@Data
public class AdminLoginVO {
    private Long id;
    private String username;
    private String nickname;
    private String role;
    private String token;
}
