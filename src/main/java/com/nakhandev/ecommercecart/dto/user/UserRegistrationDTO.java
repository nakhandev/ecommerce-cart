package com.nakhandev.ecommercecart.dto.user;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nakhandev.ecommercecart.validation.annotation.PasswordMatches;
import com.nakhandev.ecommercecart.validation.annotation.StrongPassword;
import com.nakhandev.ecommercecart.validation.annotation.ValidPhoneNumber;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;
import javax.validation.groups.Default;

@JsonInclude(JsonInclude.Include.NON_NULL)
@PasswordMatches(password = "password", confirmPassword = "confirmPassword", groups = Default.class)
public class UserRegistrationDTO {

    @NotBlank(message = "Username is required", groups = Default.class)
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters", groups = Default.class)
    @Pattern(regexp = "^[a-zA-Z0-9_-]+$", message = "Username can only contain letters, numbers, underscores, and hyphens")
    private String username;

    @NotBlank(message = "Email is required", groups = Default.class)
    @Email(message = "Please provide a valid email address", groups = Default.class)
    @Size(max = 100, message = "Email must not exceed 100 characters")
    private String email;

    @NotBlank(message = "Password is required", groups = Default.class)
    @StrongPassword(message = "Password must contain at least 8 characters, including uppercase, lowercase, number, and special character")
    private String password;

    @NotBlank(message = "Confirm password is required", groups = Default.class)
    private String confirmPassword;

    @NotBlank(message = "First name is required", groups = Default.class)
    @Size(min = 2, max = 50, message = "First name must be between 2 and 50 characters", groups = Default.class)
    @Pattern(regexp = "^[a-zA-Z\\s'-]+$", message = "First name can only contain letters, spaces, hyphens, and apostrophes")
    private String firstName;

    @NotBlank(message = "Last name is required", groups = Default.class)
    @Size(min = 2, max = 50, message = "Last name must be between 2 and 50 characters", groups = Default.class)
    @Pattern(regexp = "^[a-zA-Z\\s'-]+$", message = "Last name can only contain letters, spaces, hyphens, and apostrophes")
    private String lastName;

    @ValidPhoneNumber(message = "Please provide a valid phone number")
    private String phoneNumber;

    // Optional fields for enhanced registration
    @Size(max = 15, message = "Referral code must not exceed 15 characters")
    private String referralCode;

    @Pattern(regexp = "^(MALE|FEMALE|OTHER|NOT_SPECIFIED)$",
             message = "Gender must be one of: MALE, FEMALE, OTHER, NOT_SPECIFIED")
    private String gender = "NOT_SPECIFIED";

    @Size(max = 500, message = "Address must not exceed 500 characters")
    private String address;

    @Pattern(regexp = "^\\d{6}(-\\d{4})?$", message = "Please provide a valid postal code")
    private String postalCode;

    @Size(max = 100, message = "City name must not exceed 100 characters")
    private String city;

    @Size(max = 100, message = "Country name must not exceed 100 characters")
    private String country = "India";

    // Constructors
    public UserRegistrationDTO() {}

    // Getters and Setters
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    // Validation methods
    public boolean isPasswordMatching() {
        return password != null && password.equals(confirmPassword);
    }

    public String getFullName() {
        return firstName + " " + lastName;
    }

    // Conversion method to entity (without password encoding - handled by service)
    public com.nakhandev.ecommercecart.model.User toEntity() {
        com.nakhandev.ecommercecart.model.User user = new com.nakhandev.ecommercecart.model.User();
        user.setUsername(this.username);
        user.setEmail(this.email);
        user.setPassword(this.password); // Will be encoded by service
        user.setFirstName(this.firstName);
        user.setLastName(this.lastName);
        user.setPhoneNumber(this.phoneNumber);
        user.setIsActive(true);
        user.setRole(com.nakhandev.ecommercecart.model.User.Role.CUSTOMER);

        return user;
    }
}
