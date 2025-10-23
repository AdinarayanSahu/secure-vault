package org.groupprojects.securevault.model;

public class User {
    private int userId;
    private String username;
    private String password;
    private String name;
    private int age;
    private String email;
    private String phone;
    private String address;
    private String panNo;
    private String aadhaarNo;

    public User() {}

    public User(String username, String password, String name, int age, String email, String mobile, String address, String panNo, String aadhaarNo) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.age = age;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.panNo = panNo;
        this.aadhaarNo = aadhaarNo;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String mobile) {
        this.phone = mobile;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPanNo() {
        return panNo;
    }

    public void setPanNo(String panNo) {
        this.panNo = panNo;
    }

    public String getAadhaarNo() {
        return aadhaarNo;
    }

    public void setAadhaarNo(String aadhaarNo) {
        this.aadhaarNo = aadhaarNo;
    }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", email='" + email + '\'' +
                ", mobile='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", panNo='" + panNo + '\'' +
                ", aadhaarNo='" + aadhaarNo + '\'' +
                '}';
    }
}