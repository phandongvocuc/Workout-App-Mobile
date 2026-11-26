package com.hydrofit.backend.controller;

import com.hydrofit.backend.dto.AuthDtos.LoginRequest;
import com.hydrofit.backend.dto.AuthDtos.LoginResponse;
import com.hydrofit.backend.dto.AuthDtos.UserDto;
import com.hydrofit.backend.model.AppUser;
import com.hydrofit.backend.repository.AppUserRepository;
import com.hydrofit.backend.service.SessionService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AppUserRepository userRepository;
    private final SessionService sessionService;

    public AuthController(AppUserRepository userRepository, SessionService sessionService) {
        this.userRepository = userRepository;
        this.sessionService = sessionService;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        String email = request.email().trim();
        String password = request.password();

        // 1. Check hardcoded Admin credentials first
        if (SessionService.ADMIN_EMAIL.equalsIgnoreCase(email)) {
            if (SessionService.ADMIN_PASSWORD.equals(password)) {
                String token = sessionService.createSession(
                        0L,
                        SessionService.ADMIN_EMAIL,
                        SessionService.ROLE_ADMIN
                );
                return ResponseEntity.ok(new LoginResponse(
                        token,
                        SessionService.ROLE_ADMIN,
                        UserDto.adminProfile(SessionService.ADMIN_EMAIL)
                ));
            }
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Invalid admin email or password."));
        }

        // 2. Check member user in PostgreSQL (plain-text password comparison)
        AppUser user = userRepository.findByEmailIgnoreCase(email).orElse(null);
        if (user == null || !user.getPassword().equals(password)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Invalid email or password."));
        }

        if (!user.isActive()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("message", "Your HydroFit membership account is inactive. Please contact Admin."));
        }

        String token = sessionService.createSession(user.getId(), user.getEmail(), user.getRole());
        return ResponseEntity.ok(new LoginResponse(
                token,
                user.getRole(),
                UserDto.fromEntity(user)
        ));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        sessionService.invalidate(authHeader);
        return ResponseEntity.ok(Map.of("message", "Logged out"));
    }

    @GetMapping("/me")
    public ResponseEntity<?> me(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        SessionService.SessionInfo session = sessionService.getSession(authHeader);
        if (session == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Session expired or invalid. Please log in again."));
        }
        if (SessionService.ROLE_ADMIN.equals(session.role())) {
            return ResponseEntity.ok(UserDto.adminProfile(session.email()));
        }
        return userRepository.findById(session.userId())
                .<ResponseEntity<?>>map(user -> ResponseEntity.ok(UserDto.fromEntity(user)))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User account not found.")));
    }
}

