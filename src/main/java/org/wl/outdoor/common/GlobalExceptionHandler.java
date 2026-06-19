package org.wl.outdoor.common;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(RuntimeException.class)
    public Result<Void> handleRuntimeException(RuntimeException e)
    {
        //e.printStackTrace();
        return Result.fail(e.getMessage());
    }
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e)
    {
        //e.printStackTrace();
        return Result.fail("系统异常，请联系管理员");
    }
}
