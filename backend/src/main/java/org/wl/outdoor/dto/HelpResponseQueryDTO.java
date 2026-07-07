package org.wl.outdoor.dto;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class HelpResponseQueryDTO {
    private Integer page = 1;

    private Integer size = 10;

    /**
     * 求助事件ID
     */
    private Long helpId;

    /**
     * 响应者用户ID
     */
    private Long responderId;

    /**
     * 响应状态：1已响应，2取消响应
     */
    private Integer responseStatus;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endTime;
}
