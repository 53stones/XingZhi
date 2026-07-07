package org.wl.outdoor.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class SysAdminVO {
    private Long id;
    private String username;
    private String nickname;
    private String role;
    private Integer status;
    private LocalDateTime createTime;

}
