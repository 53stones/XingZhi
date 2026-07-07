package org.wl.outdoor.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class HelpEventDetailVO {
    private Long id;

    private Integer helpMode;

    private String helpModeName;

    private String helpType;

    private Integer emergencyLevel;

    private String emergencyLevelName;

    private String notifyColor;

    private String description;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private Integer radius;

    private String imageUrls;

    private Integer status;

    private String statusName;

    private Long requesterId;

    private String requesterName;

    private String requesterPhone;

    private Long responderId;

    private String responderName;

    private String responderPhone;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
