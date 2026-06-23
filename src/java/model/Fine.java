/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Fine {

    private int fineID;
    private int transactionID;
    private String reason;
    private double amount;
    private String issueDate;
    private String paidDate;
    private String paidStatus;

    public Fine() {
    }

    public Fine(int fineID, int transactionID, String reason, double amount, String issueDate, String paidDate, String paidStatus) {
        this.fineID = fineID;
        this.transactionID = transactionID;
        this.reason = reason;
        this.amount = amount;
        this.issueDate = issueDate;
        this.paidDate = paidDate;
        this.paidStatus = paidStatus;
    }

    public int getFineID() {
        return fineID;
    }

    public void setFineID(int fineID) {
        this.fineID = fineID;
    }

    public int getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(String issueDate) {
        this.issueDate = issueDate;
    }

    public String getPaidDate() {
        return paidDate;
    }

    public void setPaidDate(String paidDate) {
        this.paidDate = paidDate;
    }

    public String getPaidStatus() {
        return paidStatus;
    }

    public void setPaidStatus(String paidStatus) {
        this.paidStatus = paidStatus;
    }
    
    
}
