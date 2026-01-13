package com.spring.framework.batch;

import java.util.ArrayList;
import java.util.List;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

@Configuration
@PropertySource("classpath:/properties/quartz.properties")
public class QuartzConfig {

    
    private Environment env;

    public List<QuartzDto> schedulerSetting() {
        List<QuartzDto> items = new ArrayList<>();
       
        return items;
    }
}