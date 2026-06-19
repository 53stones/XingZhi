package org.wl.outdoor.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("help_notify_record")
public class HelpNotifyRecord {
    private Long id;

    private Long helpId;

    private Long receiverId;

    private Integer emergencyLevel;

    private Integer needVibration;

    private Integer notifyStatus;

    private LocalDateTime createTime;
}
