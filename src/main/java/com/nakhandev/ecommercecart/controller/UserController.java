package com.nakhandev.ecommercecart.controller;

import com.nakhandev.ecommercecart.controller.common.BaseController;
import com.nakhandev.ecommercecart.dto.common.ApiResponse;
import com.nakhandev.ecommercecart.dto.user.UserRegistrationDTO;
import com.nakhandev.ecommercecart.dto.user.UserResponseDTO;
import com.nakhandev.ecommercecart.model.User;
import com.nakhandev.ecommercecart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*") // Configure appropriately for production
public class UserController extends BaseController {

    private final UserService userService;

    @Autowired
    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * Register a new user
     */
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserResponseDTO>> registerUser(
            @Valid @RequestBody UserRegistrationDTO registrationDTO) {

        logControllerEntry("registerUser", registrationDTO.getUsername());

        try {
            // Validate password confirmation
            if (!registrationDTO.isPasswordMatching()) {
                return createErrorResponse("Password confirmation does not match");
            }

            // Check for validation errors
            List<String> validationErrors = userService.validateUserForRegistration(
                    registrationDTO.toEntity());

            if (!validationErrors.isEmpty()) {
                return createErrorResponse("Validation failed: " + String.join(", ", validationErrors));
            }

            // Convert DTO to entity and save
            User user = registrationDTO.toEntity();
            User savedUser = userService.saveUser(user);

            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(savedUser);

            logControllerExit("registerUser", responseDTO);
            return createCreatedResponse(responseDTO);

        } catch (Exception e) {
            logError("registerUser", e);
            return createErrorResponse("Failed to register user: " + e.getMessage());
        }
    }

    /**
     * Get user profile (requires authentication)
     */
    @GetMapping("/profile")
    public ResponseEntity<ApiResponse<UserResponseDTO>> getUserProfile(
            @RequestParam Long userId) { // In real app, get from security context

        logControllerEntry("getUserProfile", userId);

        try {
            Optional<User> userOpt = userService.findUserById(userId);
            if (userOpt.isEmpty()) {
                return createNotFoundResponse("User not found with ID: " + userId);
            }

            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(userOpt.get());
            logControllerExit("getUserProfile", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getUserProfile", e);
            return createErrorResponse("Failed to get user profile: " + e.getMessage());
        }
    }

    /**
     * Update user profile
     */
    @PutMapping("/profile")
    public ResponseEntity<ApiResponse<UserResponseDTO>> updateUserProfile(
            @RequestParam Long userId, // In real app, get from security context
            @Valid @RequestBody UserRegistrationDTO updateDTO) {

        logControllerEntry("updateUserProfile", userId);

        try {
            Optional<User> existingUserOpt = userService.findUserById(userId);
            if (existingUserOpt.isEmpty()) {
                return createNotFoundResponse("User not found with ID: " + userId);
            }

            User existingUser = existingUserOpt.get();

            // Update user information
            existingUser.setFirstName(updateDTO.getFirstName());
            existingUser.setLastName(updateDTO.getLastName());
            existingUser.setPhoneNumber(updateDTO.getPhoneNumber());

            // Update email if changed (with validation)
            if (!existingUser.getEmail().equals(updateDTO.getEmail())) {
                if (userService.existsByEmail(updateDTO.getEmail())) {
                    return createErrorResponse("Email is already in use");
                }
                existingUser.setEmail(updateDTO.getEmail());
            }

            User updatedUser = userService.saveUser(existingUser);
            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(updatedUser);

            logControllerExit("updateUserProfile", responseDTO);
            return createSuccessResponse("Profile updated successfully", responseDTO);

        } catch (Exception e) {
            logError("updateUserProfile", e);
            return createErrorResponse("Failed to update profile: " + e.getMessage());
        }
    }

    /**
     * Get all users (admin only)
     */
    @GetMapping
    public ResponseEntity<ApiResponse<List<UserResponseDTO>>> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {

        logControllerEntry("getAllUsers", page, size);

        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<User> userPage = userService.findAllUsers(pageable);

            List<UserResponseDTO> userDTOs = userPage.getContent().stream()
                    .map(UserResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            // For simplicity, returning list instead of paged response
            // In production, consider using PagedResponse
            logControllerExit("getAllUsers", userDTOs);
            return createSuccessResponse(userDTOs);

        } catch (Exception e) {
            logError("getAllUsers", e);
            return createErrorResponse("Failed to get users: " + e.getMessage());
        }
    }

    /**
     * Get user by ID (admin only)
     */
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UserResponseDTO>> getUserById(@PathVariable Long id) {

        logControllerEntry("getUserById", id);

        try {
            Optional<User> userOpt = userService.findUserById(id);
            if (userOpt.isEmpty()) {
                return createNotFoundResponse("User not found with ID: " + id);
            }

            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(userOpt.get());
            logControllerExit("getUserById", responseDTO);
            return createSuccessResponse(responseDTO);

        } catch (Exception e) {
            logError("getUserById", e);
            return createErrorResponse("Failed to get user: " + e.getMessage());
        }
    }

    /**
     * Search users
     */
    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<UserResponseDTO>>> searchUsers(
            @RequestParam String searchTerm) {

        logControllerEntry("searchUsers", searchTerm);

        try {
            List<User> users = userService.searchUsers(searchTerm);
            List<UserResponseDTO> userDTOs = users.stream()
                    .map(UserResponseDTO::fromEntity)
                    .collect(Collectors.toList());

            logControllerExit("searchUsers", userDTOs);
            return createSuccessResponse(userDTOs);

        } catch (Exception e) {
            logError("searchUsers", e);
            return createErrorResponse("Failed to search users: " + e.getMessage());
        }
    }

    /**
     * Activate user (admin only)
     */
    @PutMapping("/{id}/activate")
    public ResponseEntity<ApiResponse<UserResponseDTO>> activateUser(@PathVariable Long id) {

        logControllerEntry("activateUser", id);

        try {
            User activatedUser = userService.activateUser(id);
            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(activatedUser);

            logControllerExit("activateUser", responseDTO);
            return createSuccessResponse("User activated successfully", responseDTO);

        } catch (Exception e) {
            logError("activateUser", e);
            return createErrorResponse("Failed to activate user: " + e.getMessage());
        }
    }

    /**
     * Deactivate user (admin only)
     */
    @PutMapping("/{id}/deactivate")
    public ResponseEntity<ApiResponse<UserResponseDTO>> deactivateUser(@PathVariable Long id) {

        logControllerEntry("deactivateUser", id);

        try {
            User deactivatedUser = userService.deactivateUser(id);
            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(deactivatedUser);

            logControllerExit("deactivateUser", responseDTO);
            return createSuccessResponse("User deactivated successfully", responseDTO);

        } catch (Exception e) {
            logError("deactivateUser", e);
            return createErrorResponse("Failed to deactivate user: " + e.getMessage());
        }
    }

    /**
     * Change user role (admin only)
     */
    @PutMapping("/{id}/role")
    public ResponseEntity<ApiResponse<UserResponseDTO>> changeUserRole(
            @PathVariable Long id,
            @RequestParam User.Role role) {

        logControllerEntry("changeUserRole", id, role);

        try {
            User updatedUser = userService.changeUserRole(id, role);
            UserResponseDTO responseDTO = UserResponseDTO.fromEntity(updatedUser);

            logControllerExit("changeUserRole", responseDTO);
            return createSuccessResponse("User role updated successfully", responseDTO);

        } catch (Exception e) {
            logError("changeUserRole", e);
            return createErrorResponse("Failed to change user role: " + e.getMessage());
        }
    }

    /**
     * Delete user (admin only)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteUser(@PathVariable Long id) {

        logControllerEntry("deleteUser", id);

        try {
            userService.deleteUserById(id);

            logControllerExit("deleteUser", "User deleted");
            return createSuccessResponse("User deleted successfully");

        } catch (Exception e) {
            logError("deleteUser", e);
            return createErrorResponse("Failed to delete user: " + e.getMessage());
        }
    }

    /**
     * Get user statistics (admin only)
     */
    @GetMapping("/stats")
    public ResponseEntity<ApiResponse<UserStats>> getUserStats() {

        logControllerEntry("getUserStats");

        try {
            long activeUsers = userService.countActiveUsers();
            long totalUsers = userService.findAllUsers().size();
            long inactiveUsers = totalUsers - activeUsers;

            UserStats stats = new UserStats(totalUsers, activeUsers, inactiveUsers);

            logControllerExit("getUserStats", stats);
            return createSuccessResponse(stats);

        } catch (Exception e) {
            logError("getUserStats", e);
            return createErrorResponse("Failed to get user statistics: " + e.getMessage());
        }
    }

    // Inner class for user statistics
    public static class UserStats {
        private long totalUsers;
        private long activeUsers;
        private long inactiveUsers;

        public UserStats(long totalUsers, long activeUsers, long inactiveUsers) {
            this.totalUsers = totalUsers;
            this.activeUsers = activeUsers;
            this.inactiveUsers = inactiveUsers;
        }

        // Getters
        public long getTotalUsers() { return totalUsers; }
        public long getActiveUsers() { return activeUsers; }
        public long getInactiveUsers() { return inactiveUsers; }
    }
}
