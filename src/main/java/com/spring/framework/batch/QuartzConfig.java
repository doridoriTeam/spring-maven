package com.spring.framework.batch;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

@Configuration
@PropertySource("classpath:/properties/quartz.properties")
public class QuartzConfig {

    @Autowired
    private Environment env;

    @Bean(name = "schedulerSetting")
    public List<QuartzDto> schedulerSetting() {
        List<QuartzDto> list = new ArrayList<>();
        String items = env.getProperty("job.list");
        if (items != null) {
            String[] itemArray = items.split(",");
            for (String item : itemArray) {
                String jobName = env.getProperty(item + ".jobName");
                String jobGroup = env.getProperty(item + ".jobGroup");
                String triggerName = env.getProperty(item + ".triggerName");
                String triggerGroup = env.getProperty(item + ".triggerGroup");
                
                QuartzDto dto = new QuartzDto(jobName, jobGroup, triggerName, triggerGroup);
                list.add(dto);
            }
        return list;
    }
}