package org.wl.outdoor.common;

public class LoginAdminContext {
    private static final ThreadLocal<Long> ADMIN_ID = new ThreadLocal<>();
    private static final ThreadLocal<String> USERNAME = new ThreadLocal<>();
    private static final ThreadLocal<String> ROLE = new ThreadLocal<>();

    public static void set(Long adminId, String username, String role) {
        ADMIN_ID.set(adminId);
        USERNAME.set(username);
        ROLE.set(role);
    }

    public static Long getAdminId() {
        return ADMIN_ID.get();
    }

    public static String getUsername() {
        return USERNAME.get();
    }

    public static String getRole() {
        return ROLE.get();
    }

    public static boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(ROLE.get());
    }

    public static void clear() {
        ADMIN_ID.remove();
        USERNAME.remove();
        ROLE.remove();
    }
}
