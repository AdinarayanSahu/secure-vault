package org.groupprojects.securevault.model;

public class Account {
    private int accountNo;
    private int userId;
    private String name;
    private double balance;

    // 🔹 Default constructor
    public Account() {}

    // 🔹 Constructor for creating new account (without account number)
    public Account(int userId, String name, double balance) {
        this.userId = userId;
        this.name = name;
        this.balance = balance;
    }

    // 🔹 Constructor with all fields (for fetching from DB)
    public Account(int accountNo, int userId, String name, double balance) {
        this.accountNo = accountNo;
        this.userId = userId;
        this.name = name;
        this.balance = balance;
    }

    // 🔹 Getters and Setters
    public int getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(int accountNo) {
        this.accountNo = accountNo;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }

    // 🔹 For debugging
    @Override
    public String toString() {
        return "Account{" +
                "accountNo=" + accountNo +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", balance=" + balance +
                '}';
    }
}
