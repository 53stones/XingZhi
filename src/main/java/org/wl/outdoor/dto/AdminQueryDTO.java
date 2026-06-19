package org.wl.outdoor.dto;

import lombok.Data;

@Data
public class AdminQueryDTO {
    private Integer page=1;
    private Integer size=10;
    private String keyword;
    private Integer status;
}
