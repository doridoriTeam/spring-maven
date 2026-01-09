package com.spring.framework.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.slf4j.Logger;
import org.springframework.core.io.ClassPathResource;

import com.spring.framework.interceptor.AuthenticInterceptor;

public class CommonProperties {
    private final Logger log = org.slf4j.LoggerFactory.getLogger(AuthenticInterceptor.class);
    private static final Properties PROPERTIES = new Properties();

    private String location;

    public void setLocation(String location) {
        this.location = location;
    }

    public void init(){
        try(InputStream inputStream = new ClassPathResource(WebUtil.filePathBlackList(location)).getInputStream()) {
            PROPERTIES.load(inputStream);
        } catch (IOException e) {
            log.error("loadProperpties method Exception : ", e);
        }
    }

    public static String getProperty(String keyName){
        return PROPERTIES.getProperty(keyName);
    }
}
