package com.spring.framework.exception;

public class BizException extends Exception {
    
    private int statusCode;
    private String subCode;
    private final String bizMessage;
    
    public BizException(int statusCode, String subCode, String bizMessage) {
        super(bizMessage);
        this.statusCode = statusCode;
        this.subCode = subCode;
        this.bizMessage = bizMessage;
    }

    public BizException(String bizMessage) {
        super(bizMessage);
        this.bizMessage = bizMessage;
    }

    public int getStatusCode() {
        return statusCode;
    }
    
    public String getSubCode() {
        return subCode;
    }

    public String getBizMessage() {
        return bizMessage;
    }
}
