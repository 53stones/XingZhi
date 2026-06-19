package org.wl.outdoor.util;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.digest.BCrypt;
import org.springframework.beans.factory.BeanFactory;

public class PasswordUtil {

    public static String encode(String password) {
        if (StrUtil.isBlank(password)) {
            throw new RuntimeException("密码不能为空");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    public static boolean matches(String rawPassword, String dbPassword) {
        if (StrUtil.isBlank(rawPassword) || StrUtil.isBlank(dbPassword)) {
            return false;
        }

        if (isBcrypt(dbPassword)) {
            return BCrypt.checkpw(rawPassword, dbPassword);
        }

        return rawPassword.equals(dbPassword);
    }

    public static boolean isBcrypt(String password) {
        return StrUtil.isNotBlank(password)
                && (password.startsWith("$2a$")
                || password.startsWith("$2b$")
                || password.startsWith("$2y$"));
    }
}

