package org.wl.outdoor.dto;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AppHelpEventCreateDTO {
    private Integer helpMode;
    private String helpType;
    private Integer emergencyLevel;
    private String description;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Integer radius;
    private String imageUrls;
}
