package com.nakhandev.ecommercecart.service;

import com.nakhandev.ecommercecart.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface UserService {

    // Basic CRUD operations
    User saveUser(User user);

    Optional<User> findUserById(Long id);

    List<User> findAllUsers();

    Page<User> findAllUsers(Pageable pageable);

    void deleteUserById(Long id);

    // Authentication related methods
    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    Optional<User> findByUsernameOrEmail(String username, String email);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    // User management methods
    List<User> findAllActiveUsers();

    List<User> findByRole(User.Role role);

    List<User> findUsersCreatedBetween(LocalDateTime startDate, LocalDateTime endDate);

    long countActiveUsers();

    List<User> searchUsers(String searchTerm);

    // User status management
    User activateUser(Long id);

    User deactivateUser(Long id);

    User changeUserRole(Long id, User.Role role);

    // Password management
    boolean verifyPassword(String rawPassword, String encodedPassword);

    String encodePassword(String password);

    // Validation methods
    boolean isValidUserData(User user);

    List<String> validateUserForRegistration(User user);
}
