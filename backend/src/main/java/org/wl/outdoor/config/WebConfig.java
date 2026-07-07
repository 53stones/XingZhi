package org.wl.outdoor.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    private final AdminTokenInterceptor adminTokenInterceptor;
    private final AppUserTokenInterceptor appUserTokenInterceptor;

    public WebConfig(AdminTokenInterceptor adminTokenInterceptor, AppUserTokenInterceptor appUserTokenInterceptor) {
        this.adminTokenInterceptor = adminTokenInterceptor;
        this.appUserTokenInterceptor = appUserTokenInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(adminTokenInterceptor)
                .addPathPatterns("/admin/**")
                .excludePathPatterns("/admin/login");

        registry.addInterceptor(appUserTokenInterceptor)
                .addPathPatterns("/app/**")
                .excludePathPatterns("/app/auth/login", "/app/auth/register");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true);
    }
}
