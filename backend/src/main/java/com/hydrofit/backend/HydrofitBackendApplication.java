package com.hydrofit.backend;

import com.hydrofit.backend.model.AppUser;
import com.hydrofit.backend.repository.AppUserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class HydrofitBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(HydrofitBackendApplication.class, args);
    }

    @Bean
    CommandLineRunner seedDefaultMember(AppUserRepository userRepository) {
        return args -> {
            if (userRepository.count() == 0) {
                AppUser demoUser = new AppUser();
                demoUser.setEmail("member@hydrofit.com");
                demoUser.setPassword("123456");
                demoUser.setFullName("Alex Rivera");
                demoUser.setPhone("+1 555-0148");
                demoUser.setFitnessGoal("Muscle Gain");
                demoUser.setMembershipTier("HydroFit Pro");
                demoUser.setHeightCm(178.0);
                demoUser.setWeightKg(75.5);
                demoUser.setRole("USER");
                demoUser.setActive(true);
                userRepository.save(demoUser);
            }
        };
    }
}

