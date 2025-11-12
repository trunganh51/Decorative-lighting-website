package dao;

import model.User;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO: Quản lý thao tác với bảng Users, remember_tokens và password_resets
 */
public class UserDAO {

    public Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // ========================== ĐĂNG KÝ ==========================
    public boolean register(User u) {
        String sql = "INSERT INTO Users (full_name, email, password_hash, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword()); // lưu plain text
            ps.setString(4, u.getRole());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ========================== ĐĂNG NHẬP ==========================
    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email = ? AND password_hash = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password); // so sánh plain text
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ========================== REMEMBER TOKEN ==========================
    public void saveRememberToken(int userId, String token, LocalDateTime expireAt) throws SQLException {
        String sql = "INSERT INTO remember_tokens (user_id, token, expire_at) VALUES (?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setTimestamp(3, Timestamp.valueOf(expireAt));
            ps.executeUpdate();
        }
    }

    public User findByRememberToken(String token) throws SQLException {
        String sql = "SELECT u.* FROM Users u JOIN remember_tokens r ON u.user_id = r.user_id "
                + "WHERE r.token = ? AND r.expire_at > CURRENT_TIMESTAMP";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("role")
                    );
                }
            }
        }
        return null;
    }

    public void deleteRememberToken(String token) throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }

    // ========================== PASSWORD RESET ==========================
    public void saveResetToken(int userId, String token) throws SQLException {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            String deleteSql = "DELETE FROM password_resets WHERE user_id = ? OR expire_at < CURRENT_TIMESTAMP";
            try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            String insertSql = """
                INSERT INTO password_resets (user_id, email, token, expire_at, created_at, used)
                SELECT user_id, email, ?, CURRENT_TIMESTAMP + INTERVAL 1 HOUR, CURRENT_TIMESTAMP, 0
                FROM Users WHERE user_id = ?
            """;
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setString(1, token);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            conn.commit();
            conn.setAutoCommit(true);
        }
    }

    public User findByResetToken(String token) throws SQLException {
        String sql = """
            SELECT u.* FROM Users u
            JOIN password_resets p ON u.user_id = p.user_id
            WHERE p.token = ? AND p.expire_at > CURRENT_TIMESTAMP AND p.used = 0
            LIMIT 1
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("role")
                    );
                }
            }
        }
        return null;
    }

    public void deleteResetToken(String token) throws SQLException {
        String sql = "UPDATE password_resets SET used = 1 WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }

    public void updatePassword(int userId, String newPassword) throws SQLException {
        String sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newPassword); // plain text
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("password_hash"),
                            rs.getString("role")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY user_id";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getString("role")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
