package com.hydrofit.backend.controller;

import com.hydrofit.backend.dto.AuthDtos.AdminUserRequest;
import com.hydrofit.backend.dto.AuthDtos.UserDto;
import com.hydrofit.backend.model.AppUser;
import com.hydrofit.backend.repository.AppUserRepository;
import com.hydrofit.backend.service.SessionService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin/users")
public class AdminUserController {

    private final AppUserRepository userRepository;
    private final SessionService sessionService;

    public AdminUserController(AppUserRepository userRepository, SessionService sessionService) {
        this.userRepository = userRepository;
        this.sessionService = sessionService;
    }

    private ResponseEntity<?> requireAdmin(String authHeader) {
        SessionService.SessionInfo session = sessionService.getSession(authHeader);
        if (session == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Authentication required."));
        }
        if (!SessionService.ROLE_ADMIN.equals(session.role())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("message", "Admin access required."));
        }
        return null;
    }

    @GetMapping
    public ResponseEntity<?> listUsers(
            @RequestHeader(value = "Authorization", required = false) String authHeader
    ) {
        ResponseEntity<?> authError = requireAdmin(authHeader);
        if (authError != null) return authError;

        List<UserDto> users = userRepository.findAll(Sort.by(Sort.Direction.DESC, "id"))
                .stream()
                .map(UserDto::fromEntity)
                .toList();
        return ResponseEntity.ok(users);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getUser(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable Long id
    ) {
        ResponseEntity<?> authError = requireAdmin(authHeader);
        if (authError != null) return authError;

        return userRepository.findById(id)
                .<ResponseEntity<?>>map(u -> ResponseEntity.ok(UserDto.fromEntity(u)))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found.")));
    }

    @PostMapping
    public ResponseEntity<?> createUser(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @Valid @RequestBody AdminUserRequest request
    ) {
        ResponseEntity<?> authError = requireAdmin(authHeader);
        if (authError != null) return authError;

        String email = request.email().trim().toLowerCase();
        if (SessionService.ADMIN_EMAIL.equalsIgnoreCase(email)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Cannot create a user with the reserved admin email."));
        }
        if (userRepository.existsByEmailIgnoreCase(email)) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", "An account with this email already exists."));
        }
        if (request.password() == null || request.password().isBlank()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Password is required when creating a user."));
        }

        AppUser user = new AppUser();
        user.setEmail(email);
        user.setPassword(request.password());
        user.setFullName(request.fullName().trim());
        user.setPhone(blankToNull(request.phone()));
        user.setFitnessGoal(defaultIfBlank(request.fitnessGoal(), "General Fitness"));
        user.setMembershipTier(defaultIfBlank(request.membershipTier(), "Standard"));
        user.setHeightCm(request.heightCm());
        user.setWeightKg(request.weightKg());
        user.setAge(request.age());
        user.setGender(blankToNull(request.gender()));
        user.setRole(SessionService.ROLE_USER);
        user.setActive(request.active() == null || request.active());

        AppUser saved = userRepository.save(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserDto.fromEntity(saved));
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateUser(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable Long id,
            @Valid @RequestBody AdminUserRequest request
    ) {
        ResponseEntity<?> authError = requireAdmin(authHeader);
        if (authError != null) return authError;

        AppUser existing = userRepository.findById(id).orElse(null);
        if (existing == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "User not found."));
        }

        String newEmail = request.email().trim().toLowerCase();
        if (SessionService.ADMIN_EMAIL.equalsIgnoreCase(newEmail)) {
            return ResponseEntity.badRequest()
                    .body(Map.of("message", "Cannot use the reserved admin email."));
        }
        if (!existing.getEmail().equalsIgnoreCase(newEmail) && userRepository.existsByEmailIgnoreCase(newEmail)) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("message", "Another account already uses this email."));
        }

        existing.setEmail(newEmail);
        if (request.password() != null && !request.password().isBlank()) {
            existing.setPassword(request.password());
        }
        existing.setFullName(request.fullName().trim());
        existing.setPhone(blankToNull(request.phone()));
        existing.setFitnessGoal(defaultIfBlank(request.fitnessGoal(), "General Fitness"));
        existing.setMembershipTier(defaultIfBlank(request.membershipTier(), "Standard"));
        existing.setHeightCm(request.heightCm());
        existing.setWeightKg(request.weightKg());
        existing.setAge(request.age());
        existing.setGender(blankToNull(request.gender()));
        if (request.active() != null) {
            existing.setActive(request.active());
        }

        AppUser saved = userRepository.save(existing);
        return ResponseEntity.ok(UserDto.fromEntity(saved));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteUser(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @PathVariable Long id
    ) {
        ResponseEntity<?> authError = requireAdmin(authHeader);
        if (authError != null) return authError;

        if (!userRepository.existsById(id)) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "User not found."));
        }
        userRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("message", "User deleted successfully."));
    }

    private static String blankToNull(String value) {
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    private static String defaultIfBlank(String value, String fallback) {
        return (value == null || value.isBlank()) ? fallback : value.trim();
    }
}

