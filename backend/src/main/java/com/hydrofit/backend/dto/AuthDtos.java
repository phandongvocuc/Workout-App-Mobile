package com.hydrofit.backend.dto;

import com.hydrofit.backend.model.AppUser;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

import java.time.Instant;

public class AuthDtos {

    public record LoginRequest(
            @NotBlank @Email String email,
            @NotBlank String password
    ) {}

    public record UserDto(
            Long id,
            String email,
            String fullName,
            String phone,
            String fitnessGoal,
            String membershipTier,
            Double heightCm,
            Double weightKg,
            String role,
            boolean active,
            Instant createdAt
    ) {
        public static UserDto fromEntity(AppUser u) {
            return new UserDto(
                    u.getId(),
                    u.getEmail(),
                    u.getFullName(),
                    u.getPhone(),
                    u.getFitnessGoal(),
                    u.getMembershipTier(),
                    u.getHeightCm(),
                    u.getWeightKg(),
                    u.getRole(),
                    u.isActive(),
                    u.getCreatedAt()
            );
        }

        public static UserDto adminProfile(String email) {
            return new UserDto(
                    0L,
                    email,
                    "HydroFit Administrator",
                    null,
                    null,
                    "Admin",
                    null,
                    null,
                    "ADMIN",
                    true,
                    Instant.now()
            );
        }
    }

    public record LoginResponse(
            String token,
            String role,
            UserDto user
    ) {}

    public record AdminUserRequest(
            @NotBlank @Email String email,
            String password,
            @NotBlank String fullName,
            String phone,
            String fitnessGoal,
            String membershipTier,
            Double heightCm,
            Double weightKg,
            Boolean active
    ) {}

    public record UpdateProfileRequest(
            @NotBlank String fullName,
            String phone,
            String fitnessGoal,
            Double heightCm,
            Double weightKg,
            String password
    ) {}
}

