package org.groupprojects.securevault.model;

public class LoanType {
    private int loanTypeId;
    private String loanName;
    private double interestRate;
    private double maxAmount;
    private double minAmount;
    private int maxTenureMonths;
    private String description;

    // Default constructor
    public LoanType() {}

    // Constructor with all fields
    public LoanType(int loanTypeId, String loanName, double interestRate,
                   double maxAmount, double minAmount, int maxTenureMonths, String description) {
        this.loanTypeId = loanTypeId;
        this.loanName = loanName;
        this.interestRate = interestRate;
        this.maxAmount = maxAmount;
        this.minAmount = minAmount;
        this.maxTenureMonths = maxTenureMonths;
        this.description = description;
    }

    // Getters and Setters
    public int getLoanTypeId() {
        return loanTypeId;
    }

    public void setLoanTypeId(int loanTypeId) {
        this.loanTypeId = loanTypeId;
    }

    public String getLoanName() {
        return loanName;
    }

    public void setLoanName(String loanName) {
        this.loanName = loanName;
    }

    public double getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(double interestRate) {
        this.interestRate = interestRate;
    }

    public double getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(double maxAmount) {
        this.maxAmount = maxAmount;
    }

    public double getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(double minAmount) {
        this.minAmount = minAmount;
    }

    public int getMaxTenureMonths() {
        return maxTenureMonths;
    }

    public void setMaxTenureMonths(int maxTenureMonths) {
        this.maxTenureMonths = maxTenureMonths;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
