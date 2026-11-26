package com.hydrofit.backend.service;

import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class SessionService {

    public static final String ADMIN_EMAIL = "admin@hydrofit.com";
    public static final String ADMIN_PASSWORD = "admin123";
    public static final String ROLE_ADMIN = "ADMIN";
    public static final String ROLE_USER = "USER";

    public record SessionInfo(Long userId, String email, String role) {}

    private final Map<String, SessionInfo> sessions = new ConcurrentHashMap<>();

    public String createSession(Long userId, String email, String role) {
        String token = UUID.randomUUID().toString();
        sessions.put(token, new SessionInfo(userId, email, role));
        return token;
    }

    public SessionInfo getSession(String authHeader) {
        if (authHeader == null || authHeader.isBlank()) {
            return null;
        }
        String token = authHeader.startsWith("Bearer ")
                ? authHeader.substring(7).trim()
                : authHeader.trim();
        return sessions.get(token);
    }

    public void invalidate(String authHeader) {
        if (authHeader == null || authHeader.isBlank()) {
            return;
        }
        String token = authHeader.startsWith("Bearer ")
                ? authHeader.substring(7).trim()
                : authHeader.trim();
        sessions.remove(token);
    }

    public boolean isAdminCredentials(String email, String password) {
        return email != null
                && password != null
                && ADMIN_EMAIL.equalsIgnoreCase(email.trim())
                && ADMIN_PASSWORD.equals(password);
    }
}

