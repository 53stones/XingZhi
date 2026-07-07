package org.wl.outdoor.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("emergency_contact")
public class EmergencyContact {
    private Long id;
    private Long userId;
    private String name;
    private String phone;
    private String relationType;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
