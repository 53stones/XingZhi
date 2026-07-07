package org.wl.outdoor.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class HelpResponseVO {
    private Long id;

    private Long helpId;

    private String helpType;

    private Integer emergencyLevel;

    private String emergencyLevelName;

    private Long responderId;

    private String responderName;

    private String responderPhone;

    private BigDecimal distance;

    private Integer responseStatus;

    private String responseStatusName;

    private LocalDateTime responseTime;
}
