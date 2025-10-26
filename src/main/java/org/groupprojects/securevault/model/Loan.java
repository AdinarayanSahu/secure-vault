package org.groupprojects.securevault.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Loan {
    private int loanId;
    private int userId;
    private int accountNo;
    private int loanTypeId;
    private String loanTypeName;
    private double loanAmount;
    private double interestRate;
    private int tenureMonths;
    private double monthlyEmi;
    private double totalAmount;
    private String status;
    private Timestamp applicationDate;
    private Timestamp approvalDate;
    private Timestamp disbursementDate;
    private String purpose;

    // Default constructor
    public Loan() {}

    // Constructor for loan application
    public Loan(int userId, int accountNo, int loanTypeId, double loanAmount,
                double interestRate, int tenureMonths, String purpose) {
        this.userId = userId;
        this.accountNo = accountNo;
        this.loanTypeId = loanTypeId;
        this.loanAmount = loanAmount;
        this.interestRate = interestRate;
        this.tenureMonths = tenureMonths;
        this.purpose = purpose;
        calculateEmiAndTotal();
    }

    // Calculate EMI and total amount
    public void calculateEmiAndTotal() {
        double r = interestRate / (12 * 100); // Monthly interest rate
        double n = tenureMonths;

        if (r > 0) {
            this.monthlyEmi = (loanAmount * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);
        } else {
            this.monthlyEmi = loanAmount / n;
        }

        this.totalAmount = monthlyEmi * tenureMonths;

        // Round to 2 decimal places
        this.monthlyEmi = Math.round(this.monthlyEmi * 100.0) / 100.0;
        this.totalAmount = Math.round(this.totalAmount * 100.0) / 100.0;
    }

    // Getters and Setters
    public int getLoanId() {
        return loanId;
    }

    public void setLoanId(int loanId) {
        this.loanId = loanId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getAccountNo() {
        return accountNo;
    }

    public void setAccountNo(int accountNo) {
        this.accountNo = accountNo;
    }

    public int getLoanTypeId() {
        return loanTypeId;
    }

    public void setLoanTypeId(int loanTypeId) {
        this.loanTypeId = loanTypeId;
    }

    public String getLoanTypeName() {
        return loanTypeName;
    }

    public void setLoanTypeName(String loanTypeName) {
        this.loanTypeName = loanTypeName;
    }

    public double getLoanAmount() {
        return loanAmount;
    }

    public void setLoanAmount(double loanAmount) {
        this.loanAmount = loanAmount;
        calculateEmiAndTotal();
    }

    public double getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
        calculateEmiAndTotal();
    }

    public int getTenureMonths() {
        return tenureMonths;
    }

    public void setTenureMonths(int tenureMonths) {
        this.tenureMonths = tenureMonths;
        calculateEmiAndTotal();
    }

    public double getMonthlyEmi() {
        return monthlyEmi;
    }

    public void setMonthlyEmi(double monthlyEmi) {
        this.monthlyEmi = monthlyEmi;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getApplicationDate() {
        return applicationDate;
    }

    public void setApplicationDate(Timestamp applicationDate) {
        this.applicationDate = applicationDate;
    }

    public Timestamp getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(Timestamp approvalDate) {
        this.approvalDate = approvalDate;
    }

    public Timestamp getDisbursementDate() {
        return disbursementDate;
    }

    public void setDisbursementDate(Timestamp disbursementDate) {
        this.disbursementDate = disbursementDate;
    }

    public String getPurpose() {
        return purpose;
    }

    public void setPurpose(String purpose) {
        this.purpose = purpose;
    }
}
