package org.wl.outdoor.dto;

import lombok.Data;

@Data
public class AdminCreateDTO {
    private String username;
    private String password;
    private String nickname;
    //只能超级管理员添加普通管理员，超级管理员只能从数据库添加
}
