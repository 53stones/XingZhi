package org.wl.outdoor.entity;

import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("help_event")
public class HelpEvent {
    private Long id;

    private Long requesterId;

    private Integer helpMode;

    private String helpType;

    private Integer emergencyLevel;

    private String description;

    private BigDecimal latitude;

    private BigDecimal longitude;

    private Integer radius;

    private String imageUrls;

    private Integer status;

    private Long responderId;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;
}
