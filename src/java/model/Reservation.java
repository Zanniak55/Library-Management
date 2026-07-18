package model;

public class Reservation {
    private int reservationID;
    private int memberID;
    private String isbn;
    private String reservationDate;
    private String status;

    // join fields
    private String bookTitle;
    private String memberName;

    public Reservation() {
    }

    public Reservation(int reservationID, int memberID, String isbn, String reservationDate, String status) {
        this.reservationID = reservationID;
        this.memberID = memberID;
        this.isbn = isbn;
        this.reservationDate = reservationDate;
        this.status = status;
    }

    public int getReservationID() {
        return reservationID;
    }

    public void setReservationID(int reservationID) {
        this.reservationID = reservationID;
    }

    public int getMemberID() {
        return memberID;
    }

    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getReservationDate() {
        return reservationDate;
    }

    public void setReservationDate(String reservationDate) {
        this.reservationDate = reservationDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }
}
