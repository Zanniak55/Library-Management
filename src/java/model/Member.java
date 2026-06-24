package model;

/**
 * Model class – ánh xạ bảng Member trong CSDL Bảng: Member (MemberID, FullName,
 * Phone, Email, Address, MemberType, MembershipDate, Status, Username,
 * Password)
 *
 * @author Member B – Quản lý Thành viên
 */
public class Member {

    private int memberID;
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String memberType;
    private String membershipDate;
    private String status;
    private String username;
    private String password;

    public Member() {
    }

    public Member(int memberID, String fullName, String phone, String email,
            String address, String memberType, String membershipDate,
            String status, String username, String password) {
        this.memberID = memberID;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.memberType = memberType;
        this.membershipDate = membershipDate;
        this.status = status;
        this.username = username;
        this.password = password;
    }

    public int getMemberID() {
        return memberID;
    }

    public void setMemberID(int memberID) {
        this.memberID = memberID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getMemberType() {
        return memberType;
    }

    public void setMemberType(String memberType) {
        this.memberType = memberType;
    }

    public String getMembershipDate() {
        return membershipDate;
    }

    public void setMembershipDate(String membershipDate) {
        this.membershipDate = membershipDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    @Override
    public String toString() {
        return "Member{memberID=" + memberID
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", memberType='" + memberType + '\''
                + ", status='" + status + '\'' + '}';
    }
}
