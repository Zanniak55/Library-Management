/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Lenovo
 */
public class Transaction {

    private int transactionID;
    private String borrowDate;
    private String dueDate;
    private String returnDate;
    private String status;        // "Đang mượn" / "Đã trả" / "Quá hạn"
    private int memberID;
    private int staffID;
    private String memberName;

    public Transaction() {
    }

    public Transaction(int transactionID, String borrowDate, String dueDate, String returnDate, String status, int memberID, int staffID) {
        this.transactionID = transactionID;
        this.borrowDate = borrowDate;
        this.dueDate = dueDate;
        this.returnDate = returnDate;
        this.status = status;
        this.memberID = memberID;
        this.staffID = staffID;
    }

    public int getTransactionID() {
        return transactionID;
    }

    public void setTransactionID(int transactionID) {
        this.transactionID = transactionID;
    }

    public String getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(String borrowDate) {
        this.borrowDate = borrowDate;
    }

    public String getDueDate() {
        return dueDate;
    }

    public void setDueDate(String dueDate) {
        this.dueDate = dueDate;
    }

    public String getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(String returnDate) {
        this.returnDate = returnDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getMemberID() {
        return memberID;
    }

    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }

    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }
    
    private String bookTitles;

    public String getBookTitles() {
        return bookTitles;
    }

    public void setBookTitles(String bookTitles) {
        this.bookTitles = bookTitles;
    }
    
    
    

}
