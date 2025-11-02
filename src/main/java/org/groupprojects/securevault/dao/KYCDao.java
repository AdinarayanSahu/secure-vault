package org.groupprojects.securevault.dao;

import org.groupprojects.securevault.model.DBConnection;
import org.groupprojects.securevault.model.KYCRequest;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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

    // Submit KYC request
    public boolean submitKYCRequest(int userId, String email, String phone, String panNo, String aadhaarNo, String address) {
        String sql = "INSERT INTO kyc_requests (user_id, email, phone, pan_no, aadhaar_no, address, status, request_date) VALUES (?, ?, ?, ?, ?, ?, 'PENDING', NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, panNo);
            ps.setString(5, aadhaarNo);
            ps.setString(6, address);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all pending KYC requests for admin
    public List<KYCRequest> getPendingKYCRequests() {
        List<KYCRequest> requests = new ArrayList<>();
        String sql = "SELECT kr.*, u.name, l.username FROM kyc_requests kr " +
                "JOIN users u ON kr.user_id = u.user_id " +
                "JOIN login l ON u.user_id = l.user_id " +
                "WHERE kr.status = 'PENDING' ORDER BY kr.request_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                KYCRequest request = new KYCRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setUserId(rs.getInt("user_id"));
                request.setUsername(rs.getString("username"));
                request.setName(rs.getString("name"));
                request.setEmail(rs.getString("email"));
                request.setPhone(rs.getString("phone"));
                request.setPanNo(rs.getString("pan_no"));
                request.setAadhaarNo(rs.getString("aadhaar_no"));
                request.setAddress(rs.getString("address"));
                request.setStatus(rs.getString("status"));
                request.setRequestDate(rs.getTimestamp("request_date"));
                requests.add(request);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requests;
    }

    // Approve KYC request - updates user data and marks request as approved
    public boolean approveKYCRequest(int requestId) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Get request details
            String getRequestSql = "SELECT * FROM kyc_requests WHERE request_id = ? AND status = 'PENDING'";
            KYCRequest request = null;

            try (PreparedStatement ps = con.prepareStatement(getRequestSql)) {
                ps.setInt(1, requestId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        request = new KYCRequest();
                        request.setUserId(rs.getInt("user_id"));
                        request.setEmail(rs.getString("email"));
                        request.setPhone(rs.getString("phone"));
                        request.setPanNo(rs.getString("pan_no"));
                        request.setAadhaarNo(rs.getString("aadhaar_no"));
                        request.setAddress(rs.getString("address"));
                    }
                }
            }

            if (request == null) {
                return false;
            }

            // Update user's KYC data
            String updateUserSql = "UPDATE users SET email=?, mobile=?, pan_no=?, aadhaar_no=?, address=? WHERE user_id=?";
            try (PreparedStatement ps = con.prepareStatement(updateUserSql)) {
                ps.setString(1, request.getEmail());
                ps.setString(2, request.getPhone());
                ps.setString(3, request.getPanNo());
                ps.setString(4, request.getAadhaarNo());
                ps.setString(5, request.getAddress());
                ps.setInt(6, request.getUserId());
                ps.executeUpdate();
            }

            // Update request status
            String updateRequestSql = "UPDATE kyc_requests SET status='APPROVED' WHERE request_id=?";
            try (PreparedStatement ps = con.prepareStatement(updateRequestSql)) {
                ps.setInt(1, requestId);
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Reject KYC request
    public boolean rejectKYCRequest(int requestId) {
        String sql = "UPDATE kyc_requests SET status='REJECTED' WHERE request_id=? AND status='PENDING'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if user has pending KYC request
    public boolean hasPendingRequest(int userId) {
        String sql = "SELECT COUNT(*) FROM kyc_requests WHERE user_id = ? AND status = 'PENDING'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}
