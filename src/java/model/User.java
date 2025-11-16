package model;

/**
 * Represents a user of the application. Users can be customers or admins
 * depending on their role. For this simple project passwords are stored
 * in plain text (not recommended for production). The default role is
 * {@code user}.
 */
public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String role;
    private String phoneNumber;

    public User() {
    }

    public User(int id, String fullName, String email, String password, String role, String phoneNumber) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.phoneNumber = phoneNumber;
    }

    public User(String fullName, String email, String password, String role, String phoneNumber) {
        this(0, fullName, email, password, role, phoneNumber);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
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

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}