package com.spring.framework.batch;

public class QuartzDto {
    
    private final String jobName;
    private final String jobGroup;
    private final String triggerName;
    private final String triggerGroup;

    public QuartzDto(String jobName, String jobGroup, String triggerName, String triggerGroup) {
        this.jobName = jobName;
        this.jobGroup = jobGroup;
        this.triggerName = triggerName;
        this.triggerGroup = triggerGroup;

    }

    public String getJobName() {
        return jobName;
    }
    public String getJobGroup() {
        return jobGroup;
    }
    public String getTriggerName() {
        return triggerName;
    }
    public String getTriggerGroup() {
        return triggerGroup;
    }

}
