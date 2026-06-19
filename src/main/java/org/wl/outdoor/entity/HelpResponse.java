package org.wl.outdoor.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("help_response")
public class HelpResponse {
    private Long id;

    private Long helpId;

    private Long responderId;

    private BigDecimal distance;

    private Integer responseStatus;

    private LocalDateTime responseTime;
}
