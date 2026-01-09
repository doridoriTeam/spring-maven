package com.spring.framework.util;

import java.util.List;
import java.util.Map;

public class CommonUtil {
    
    /**
     * Convert Map Key to Camel Case (Only Key)
     * @param list
     * @return list
     * @throws Exception
     */
    public static List<Map<String,Object>> convertKeyToCamel(List<Map<String,Object>> list) throws Exception{
        for(Map<String,Object> map : list){
            for(String key : map.keySet()){
                String camlKey = StringToCaml(key);
                if(!camlKey.equals(key)){
                    Object value = map.get(key);
                    map.remove(key);
                    map.put(camlKey, value);
                } 
            }
        }

        return list;
    }

    private static String StringToCaml(String key){
        StringBuilder result = new StringBuilder();
        boolean nextUpper = false;

        for(char c : key.toCharArray()){
            if(c == '_' || c == '-'){
                nextUpper = true;
            }else{
                if(nextUpper){
                    result.append( Character.toUpperCase(c) );
                    nextUpper = false;
                }else{
                    result.append( Character.toLowerCase(c) );
                }
            }
        }
        return result.toString();
    }
}
