package org.groupprojects.securevault.model;

import java.sql.Timestamp;

public class KYCRequest {
    private int requestId;
    private int userId;
    private String username;
    private String name;
    private String email;
    private String phone;
    private String panNo;
    private String aadhaarNo;
    private String address;
    private String status; // PENDING, APPROVED, REJECTED
    private Timestamp requestDate;

    // Default constructor
    public KYCRequest() {}

    // Constructor for new request
    public KYCRequest(int userId, String email, String phone, String panNo, String aadhaarNo, String address) {
        this.userId = userId;
        this.email = email;
        this.phone = phone;
        this.panNo = panNo;
        this.aadhaarNo = aadhaarNo;
        this.address = address;
        this.status = "PENDING";
    }

    // Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPanNo() { return panNo; }
    public void setPanNo(String panNo) { this.panNo = panNo; }

    public String getAadhaarNo() { return aadhaarNo; }
    public void setAadhaarNo(String aadhaarNo) { this.aadhaarNo = aadhaarNo; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getRequestDate() { return requestDate; }
    public void setRequestDate(Timestamp requestDate) { this.requestDate = requestDate; }
}
