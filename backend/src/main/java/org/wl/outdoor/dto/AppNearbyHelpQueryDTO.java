package org.wl.outdoor.dto;

import lombok.Data;

@Data
public class AppNearbyHelpQueryDTO {
    private Integer page = 1;
    private Integer size = 10;
    private java.math.BigDecimal latitude;
    private java.math.BigDecimal longitude;
    private Integer radius = 3;
}
