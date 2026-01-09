package com.spring.framework.util;

import org.springframework.util.StringUtils;

public class WebUtil {
    
    public static String filePathBlackList(String valueString){
        //빈 값 체크
        if(StringUtils.hasText(valueString)){
          return "";  
        }

        valueString = valueString.replaceAll("\\.\\.", "");
        
        return valueString;
    }
}
