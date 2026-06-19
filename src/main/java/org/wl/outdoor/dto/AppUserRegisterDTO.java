package org.wl.outdoor.dto;

import lombok.Data;

@Data
public class AppUserRegisterDTO {
    private String username;
    private String password;
    private String phone;
    private String nickname;
}
