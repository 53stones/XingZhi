package org.wl.outdoor.vo;

import lombok.Data;

@Data
public class StatOverviewVO {

        /**
         * 普通用户总数
         */
        private Long userCount;

        /**
         * 管理员总数
         */
        private Long adminCount;

        /**
         * 求助事件总数
         */
        private Long helpEventCount;

        /**
         * 一键求助数量
         */
        private Long quickHelpCount;

        /**
         * 自定义求助数量
         */
        private Long customHelpCount;

        /**
         * 待响应求助数量
         */
        private Long pendingHelpCount;

        /**
         * 已响应求助数量
         */
        private Long respondedHelpCount;

        /**
         * 进行中求助数量
         */
        private Long processingHelpCount;

        /**
         * 已完成求助数量
         */
        private Long finishedHelpCount;

        /**
         * 已取消求助数量
         */
        private Long canceledHelpCount;

        /**
         * 高危求助数量
         */
        private Long dangerHelpCount;

        /**
         * 响应记录总数
         */
        private Long responseRecordCount;

        /**
         * 通知记录总数
         */
        private Long notifyRecordCount;

        /**
         * 今日求助数量
         */
        private Long todayHelpCount;

        /**
         * 响应率
         */
        private Double responseRate;
}
