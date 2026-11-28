package com.hydrofit.backend.controller;

import com.hydrofit.backend.dto.AuthDtos.UpdateProfileRequest;
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
@RequestMapping("/api/users")
public class UserProfileController {

    private final AppUserRepository userRepository;
    private final SessionService sessionService;

    public UserProfileController(AppUserRepository userRepository, SessionService sessionService) {
        this.userRepository = userRepository;
        this.sessionService = sessionService;
    }

    @GetMapping("/me")
    public ResponseEntity<?> getMyProfile(
            @RequestHeader(value = "Authorization", required = false) String authHeader
    ) {
        SessionService.SessionInfo session = sessionService.getSession(authHeader);
        if (session == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Authentication required."));
        }
        if (SessionService.ROLE_ADMIN.equals(session.role())) {
            return ResponseEntity.ok(UserDto.adminProfile(session.email()));
        }

        return userRepository.findById(session.userId())
                .<ResponseEntity<?>>map(u -> ResponseEntity.ok(UserDto.fromEntity(u)))
                .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("message", "User not found.")));
    }

    @PutMapping("/me")
    public ResponseEntity<?> updateMyProfile(
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @Valid @RequestBody UpdateProfileRequest request
    ) {
        SessionService.SessionInfo session = sessionService.getSession(authHeader);
        if (session == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("message", "Authentication required."));
        }
        if (!SessionService.ROLE_USER.equals(session.role())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("message", "Only member accounts can update their profile here."));
        }

        AppUser user = userRepository.findById(session.userId()).orElse(null);
        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("message", "User account not found."));
        }

        user.setFullName(request.fullName().trim());
        user.setPhone(request.phone() == null || request.phone().isBlank() ? null : request.phone().trim());
        if (request.fitnessGoal() != null && !request.fitnessGoal().isBlank()) {
            user.setFitnessGoal(request.fitnessGoal().trim());
        }
        user.setHeightCm(request.heightCm());
        user.setWeightKg(request.weightKg());
        user.setAge(request.age());
        user.setGender(request.gender() == null || request.gender().isBlank() ? null : request.gender().trim());
        if (request.password() != null && !request.password().isBlank()) {
            user.setPassword(request.password());
        }

        AppUser saved = userRepository.save(user);
        return ResponseEntity.ok(UserDto.fromEntity(saved));
    }
}

