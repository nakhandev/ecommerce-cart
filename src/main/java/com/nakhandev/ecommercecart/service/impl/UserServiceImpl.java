package com.nakhandev.ecommercecart.service.impl;

import com.nakhandev.ecommercecart.model.User;
import com.nakhandev.ecommercecart.repository.UserRepository;
import com.nakhandev.ecommercecart.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.validation.ConstraintViolation;
import javax.validation.Validator;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final Validator validator;

    @Autowired
    public UserServiceImpl(UserRepository userRepository,
                          PasswordEncoder passwordEncoder,
                          Validator validator) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.validator = validator;
    }

    @Override
    public User saveUser(User user) {
        logger.info("Saving user: {}", user.getUsername());

        if (user.getId() == null) {
            // New user - encode password
            if (user.getPassword() != null) {
                user.setPassword(encodePassword(user.getPassword()));
            }
        } else {
            // Existing user - preserve password if not changed
            Optional<User> existingUser = userRepository.findById(user.getId());
            if (existingUser.isPresent() && !existingUser.get().getPassword().equals(user.getPassword())) {
                user.setPassword(encodePassword(user.getPassword()));
            }
        }

        User savedUser = userRepository.save(user);
        logger.info("User saved successfully with ID: {}", savedUser.getId());
        return savedUser;
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findUserById(Long id) {
        logger.debug("Finding user by ID: {}", id);
        return userRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> findAllUsers() {
        logger.debug("Finding all users");
        return userRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Page<User> findAllUsers(Pageable pageable) {
        logger.debug("Finding all users with pagination");
        return userRepository.findAll(pageable);
    }

    @Override
    public void deleteUserById(Long id) {
        logger.info("Deleting user with ID: {}", id);
        userRepository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        logger.debug("Finding user by username: {}", username);
        return userRepository.findByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        logger.debug("Finding user by email: {}", email);
        return userRepository.findByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<User> findByUsernameOrEmail(String username, String email) {
        logger.debug("Finding user by username or email: {} or {}", username, email);
        return userRepository.findByUsernameOrEmail(username, email);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> findAllActiveUsers() {
        logger.debug("Finding all active users");
        return userRepository.findAllActiveUsers();
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> findByRole(User.Role role) {
        logger.debug("Finding users by role: {}", role);
        return userRepository.findByRole(role);
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> findUsersCreatedBetween(LocalDateTime startDate, LocalDateTime endDate) {
        logger.debug("Finding users created between {} and {}", startDate, endDate);
        return userRepository.findUsersCreatedBetween(startDate, endDate);
    }

    @Override
    @Transactional(readOnly = true)
    public long countActiveUsers() {
        return userRepository.countActiveUsers();
    }

    @Override
    @Transactional(readOnly = true)
    public List<User> searchUsers(String searchTerm) {
        logger.debug("Searching users with term: {}", searchTerm);
        return userRepository.searchUsers(searchTerm);
    }

    @Override
    public User activateUser(Long id) {
        logger.info("Activating user with ID: {}", id);
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(true);
            return userRepository.save(user);
        }
        throw new RuntimeException("User not found with ID: " + id);
    }

    @Override
    public User deactivateUser(Long id) {
        logger.info("Deactivating user with ID: {}", id);
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setIsActive(false);
            return userRepository.save(user);
        }
        throw new RuntimeException("User not found with ID: " + id);
    }

    @Override
    public User changeUserRole(Long id, User.Role role) {
        logger.info("Changing role for user ID: {} to {}", id, role);
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(role);
            return userRepository.save(user);
        }
        throw new RuntimeException("User not found with ID: " + id);
    }

    @Override
    public boolean verifyPassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    @Override
    public String encodePassword(String password) {
        return passwordEncoder.encode(password);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isValidUserData(User user) {
        Set<ConstraintViolation<User>> violations = validator.validate(user);
        return violations.isEmpty();
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> validateUserForRegistration(User user) {
        List<String> errors = new ArrayList<>();

        // Check if username already exists
        if (existsByUsername(user.getUsername())) {
            errors.add("Username is already taken");
        }

        // Check if email already exists
        if (existsByEmail(user.getEmail())) {
            errors.add("Email is already registered");
        }

        // Validate user data using Bean Validation
        Set<ConstraintViolation<User>> violations = validator.validate(user);
        for (ConstraintViolation<User> violation : violations) {
            errors.add(violation.getMessage());
        }

        return errors;
    }
}
