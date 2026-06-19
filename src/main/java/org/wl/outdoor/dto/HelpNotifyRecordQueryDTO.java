package org.wl.outdoor.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class HelpNotifyRecordQueryDTO {
    private Integer page = 1;

    private Integer size = 10;

    /**
     * 求助事件ID
     */
    private Long helpId;

    /**
     * 接收通知的用户ID
     */
    private Long receiverId;

    /**
     * 求助等级：1普通，2紧急，3高危
     */
    private Integer emergencyLevel;

    /**
     * 是否振动：0否，1是
     */
    private Integer needVibration;

    /**
     * 通知状态：0待发送，1已发送，2发送失败
     */
    private Integer notifyStatus;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
}
