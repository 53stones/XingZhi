package org.wl.outdoor.util;

import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTUtil;

import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

public class JwtUtil {

    private static final String SECRET = "outdoor_help_admin_secret";

    public static String createToken(Long adminId, String username, String role) {
        Map<String, Object> payload = new HashMap<>();

        payload.put("adminId", adminId);
        payload.put("username", username);
        payload.put("role", role);
        payload.put("expireTime", System.currentTimeMillis() + 1000L * 60 * 60 * 24);

        return JWTUtil.createToken(payload, SECRET.getBytes(StandardCharsets.UTF_8));
    }

    public static String createUserToken(Long userId, String username) {
        Map<String, Object> payload = new HashMap<>();
        payload.put("userId", userId);
        payload.put("username", username);
        payload.put("tokenType", "APP_USER");
        payload.put("expireTime", System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 7);
        return JWTUtil.createToken(payload, SECRET.getBytes(StandardCharsets.UTF_8));
    }

    public static boolean verify(String token) {
        try {
            boolean valid = JWTUtil.verify(token, SECRET.getBytes(StandardCharsets.UTF_8));

            if (!valid) {
                return false;
            }

            JWT jwt = JWTUtil.parseToken(token);
            Long expireTime = Long.valueOf(jwt.getPayload("expireTime").toString());

            return expireTime >= System.currentTimeMillis();
        } catch (Exception e) {
            return false;
        }
    }

    public static Long getAdminId(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        return Long.valueOf(jwt.getPayload("adminId").toString());
    }
    public static String getUsername(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        return jwt.getPayload("username").toString();
    }

    public static String getRole(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        return jwt.getPayload("role").toString();
    }

    public static Long getUserId(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        return Long.valueOf(jwt.getPayload("userId").toString());
    }

    public static String getTokenType(String token) {
        JWT jwt = JWTUtil.parseToken(token);
        Object tokenType = jwt.getPayload("tokenType");
        return tokenType == null ? null : tokenType.toString();
    }
}
