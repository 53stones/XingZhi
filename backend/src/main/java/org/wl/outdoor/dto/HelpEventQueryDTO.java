package org.wl.outdoor.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class HelpEventQueryDTO {
    private Integer page = 1;

    private Integer size = 10;

    /**
     * 求助模式：1一键求助，2自定义求助
     */
    private Integer helpMode;

    /**
     * 求助等级：1普通，2紧急，3高危
     */
    private Integer emergencyLevel;

    /**
     * 状态：0待响应，1已响应，2进行中，3已完成，4已取消
     */
    private Integer status;

    /**
     * 关键词：求助类型、求助描述
     */
    private String keyword;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
}
