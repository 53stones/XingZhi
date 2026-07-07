package org.wl.outdoor.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.wl.outdoor.common.LoginAdminContext;
import org.wl.outdoor.util.JwtUtil;

@Component
public class AdminTokenInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler
    ) throws Exception {

        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String authorization = request.getHeader("Authorization");

        if (authorization == null || authorization.isBlank()) {
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"未登录或 token 缺失\",\"data\":null}");
            return false;
        }

        String token = authorization.replace("Bearer ", "");

        if (!JwtUtil.verify(token)) {
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"msg\":\"token 无效或已过期\",\"data\":null}");
            return false;
        }

        Long adminId = JwtUtil.getAdminId(token);
        String username = JwtUtil.getUsername(token);
        String role = JwtUtil.getRole(token);

        LoginAdminContext.set(adminId, username, role);

        return true;
    }

    @Override
    public void afterCompletion(
            HttpServletRequest request,
            HttpServletResponse response,
            Object handler,
            Exception ex
    ) {
        LoginAdminContext.clear();
    }
}
