package org.wl.outdoor.vo;

import lombok.Data;

@Data
public class AgentChatVO {
    private String reply;
    private Boolean suggestHelp;
    private HelpEventDetailVO createdHelpEvent;
}
