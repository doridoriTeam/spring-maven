package com.spring.framework.exception;

public class SessionExpiredException extends Exception {
    
    private static final long serialVersionUID = 7882610820751717859L;
    protected String message = null;
    
    public SessionExpiredException(String message) {
        super(message);
        this.message = message;
    }

    public String getMessage() {
        return this.message;
    }
    
}
