package org.wl.outdoor.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class HelpNotifyRecordVO {
    private Long id;

    private Long helpId;

    private String helpType;

    private Integer emergencyLevel;

    private String emergencyLevelName;

    private String notifyColor;

    private Long receiverId;

    private String receiverName;

    private String receiverPhone;

    private Integer needVibration;

    private String needVibrationName;

    private Integer notifyStatus;

    private String notifyStatusName;

    private LocalDateTime createTime;
}
