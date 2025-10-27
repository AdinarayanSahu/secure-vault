package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.DBConnection;
import java.sql.*;

public class KYCDao {


    public boolean updateKYC(String username, String email, String phone, String panNo, String aadhaarNo, String address) {

        String getUserIdSql = "SELECT user_id FROM login WHERE username = ?";
        String updateSql = "UPDATE users SET email=?, mobile=?, pan_no=?, aadhaar_no=?, address=? WHERE user_id=?";

        try (Connection con = DBConnection.getConnection()) {


            int userId = -1;
            try (PreparedStatement ps1 = con.prepareStatement(getUserIdSql)) {
                ps1.setString(1, username);
                ResultSet rs = ps1.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    System.out.println("No user found with username: " + username);
                    return false;
                }
            }

            // Update users table using user_id
            try (PreparedStatement ps2 = con.prepareStatement(updateSql)) {
                ps2.setString(1, email);
                ps2.setString(2, phone);
                ps2.setString(3, panNo);
                ps2.setString(4, aadhaarNo);
                ps2.setString(5, address);
                ps2.setInt(6, userId);

                int rowsUpdated = ps2.executeUpdate();
                System.out.println("KYC Update - Rows affected: " + rowsUpdated + " for user_id: " + userId);
                return rowsUpdated > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error updating KYC: " + e.getMessage());
            return false;
        }
    }


    public boolean getKYCByUsername(String username) {
        // First get the user_id from the login table using username
        String getUserIdSql = "SELECT user_id FROM login WHERE username = ?";
        String getKYCSql = "SELECT email, mobile, pan_no, aadhaar_no, address FROM users WHERE user_id=?";

        try (Connection con = DBConnection.getConnection()) {

            int userId = -1;
            try (PreparedStatement ps1 = con.prepareStatement(getUserIdSql)) {
                ps1.setString(1, username);
                ResultSet rs = ps1.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    return false;
                }
            }


            try (PreparedStatement ps2 = con.prepareStatement(getKYCSql)) {
                ps2.setInt(1, userId);
                ResultSet rs = ps2.executeQuery();
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error getting KYC data: " + e.getMessage());
            return false;
        }
    }


    public boolean isKYCComplete(String username) {

        String getUserIdSql = "SELECT user_id FROM login WHERE username = ?";
        String getKYCSql = "SELECT email, mobile, pan_no, aadhaar_no, address FROM users WHERE user_id=?";

        try (Connection con = DBConnection.getConnection()) {


            int userId = -1;
            try (PreparedStatement ps1 = con.prepareStatement(getUserIdSql)) {
                ps1.setString(1, username);
                ResultSet rs = ps1.executeQuery();
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    return false;
                }
            }


            try (PreparedStatement ps2 = con.prepareStatement(getKYCSql)) {
                ps2.setInt(1, userId);
                ResultSet rs = ps2.executeQuery();

                if (rs.next()) {
                    String email = rs.getString("email");
                    String mobile = rs.getString("mobile");
                    String panNo = rs.getString("pan_no");
                    String aadhaarNo = rs.getString("aadhaar_no");
                    String address = rs.getString("address");


                    return email != null && !email.trim().isEmpty() &&
                            mobile != null && !mobile.trim().isEmpty() &&
                            panNo != null && !panNo.trim().isEmpty() &&
                            aadhaarNo != null && !aadhaarNo.trim().isEmpty() &&
                            address != null && !address.trim().isEmpty();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error checking KYC completeness: " + e.getMessage());
        }

        return false;
    }
}