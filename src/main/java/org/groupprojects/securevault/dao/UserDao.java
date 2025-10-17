package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.User;
import java.sql.*;

public class UserDao {

    // Get database connection
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/smartbank_db", "root", "password");
    }

    // Registers user and returns generated user_id, -1 if failed
    public int registerUserReturnId(User user) {
        int userId = -1;
        String sql = "INSERT INTO users(username, password, name, age, email, phone, address) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getName());
            ps.setInt(4, user.getAge());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getPhone());
            ps.setString(7, user.getAddress());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                // First try getGeneratedKeys
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                        System.out.println("DEBUG: Generated key via getGeneratedKeys = " + userId);
                    }
                }

                // If no key returned, use LAST_INSERT_ID()
                if (userId == -1) {
                    try (PreparedStatement ps2 = con.prepareStatement("SELECT LAST_INSERT_ID()");
                         ResultSet rs2 = ps2.executeQuery()) {
                        if (rs2.next()) {
                            userId = rs2.getInt(1);
                            System.out.println("DEBUG: Generated key via LAST_INSERT_ID() = " + userId);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return userId;
    }

    // Get user by username and password (for login)
    public User getUserByUsernameAndPassword(String username, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE username=? AND password=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Get user by user_id
    public User getUserById(int userId) {
        User user = null;
        String sql = "SELECT * FROM users WHERE user_id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // Update user profile
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET name=?, age=?, email=?, phone=?, address=? WHERE user_id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setInt(2, user.getAge());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getUserId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Helper method to map ResultSet to User object
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setName(rs.getString("name"));
        user.setAge(rs.getInt("age"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        return user;
    }
}
