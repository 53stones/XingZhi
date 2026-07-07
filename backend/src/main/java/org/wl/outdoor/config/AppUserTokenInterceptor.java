package org.wl.outdoor.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.wl.outdoor.common.LoginUserContext;
import org.wl.outdoor.util.JwtUtil;

@Component
public class AppUserTokenInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String authorization = request.getHeader("Authorization");
        if (authorization == null || authorization.isBlank()) {
            writeUnauthorized(response, "未登录或 token 缺失");
            return false;
        }

        String token = authorization.replace("Bearer ", "");
        if (!JwtUtil.verify(token) || !"APP_USER".equals(JwtUtil.getTokenType(token))) {
            writeUnauthorized(response, "token 无效或已过期");
            return false;
        }

        LoginUserContext.set(JwtUtil.getUserId(token), JwtUtil.getUsername(token));
        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        LoginUserContext.clear();
    }

    private void writeUnauthorized(HttpServletResponse response, String msg) throws Exception {
        response.setStatus(401);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"code\":401,\"msg\":\"" + msg + "\",\"data\":null}");
    }
}
