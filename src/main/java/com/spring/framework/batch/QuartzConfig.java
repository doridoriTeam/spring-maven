package com.spring.framework.batch;

import javax.sql.DataSource;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

@Configuration
public class QuartzConfig {

    private final ApplicationContext applicationContext;
    private final DataSource dataSource;

    public QuartzConfig(ApplicationContext applicationContext, DataSource dataSource) {
        this.applicationContext = applicationContext;
        this.dataSource = dataSource;
    }

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() {
        SchedulerFactoryBean schedulerFactory = new SchedulerFactoryBean();
        
        // 1. JobDetail이 Spring Bean을 주입받을 수 있도록 설정
        AutocompleteJobFactory jobFactory = new AutocompleteJobFactory();
        jobFactory.setApplicationContext(applicationContext);
        schedulerFactory.setJobFactory(jobFactory);

        // 2. 작성하신 quartz.properties 로드
        schedulerFactory.setConfigLocation(new ClassPathResource("quartz.properties"));
        
        // 3. JDBC JobStore를 위한 DataSource 설정
        schedulerFactory.setDataSource(dataSource);
        
        // 4. 앱 시작 시 바로 실행 및 기존 작업 덮어쓰기 설정
        schedulerFactory.setOverwriteExistingJobs(true);
        schedulerFactory.setAutoStartup(true);
        
        return schedulerFactory;
    }
}