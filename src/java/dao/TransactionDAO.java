/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Transaction;

/**
 *
 * @author Lenovo
 */
public class TransactionDAO extends DBContext{
    // Tìm kiếm giao dịch theo tên thành viên và trạng thái
    public List<Transaction> searchTransactions(String keyword, String status) {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID, m.FullName AS MemberName
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE (? = '' OR m.FullName LIKE ?)
              AND (? = '' OR t.Status = ?)
            ORDER BY t.TransactionID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = keyword == null ? "" : keyword.trim();
            String st = status  == null ? "" : status.trim();
            ps.setString(1, kw);
            ps.setString(2, "%" + kw + "%");
            ps.setString(3, st);
            ps.setString(4, st);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction tr = new Transaction();
                tr.setTransactionID(rs.getInt("TransactionID"));
                tr.setBorrowDate(rs.getString("BorrowDate"));
                tr.setDueDate(rs.getString("DueDate"));
                tr.setReturnDate(rs.getString("ReturnDate"));
                tr.setStatus(rs.getString("Status"));
                tr.setMemberID(rs.getInt("MemberID"));
                tr.setMemberName(rs.getString("MemberName"));
                tr.setStaffID(rs.getInt("StaffID"));
                list.add(tr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả giao dịch kèm tên thành viên
    public List<Transaction> getAllTransactions() {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID,
                   m.FullName AS MemberName
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            ORDER BY t.TransactionID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Transaction tr = new Transaction();
                tr.setTransactionID(rs.getInt("TransactionID"));
                tr.setBorrowDate(rs.getString("BorrowDate"));
                tr.setDueDate(rs.getString("DueDate"));
                tr.setReturnDate(rs.getString("ReturnDate"));
                tr.setStatus(rs.getString("Status"));
                tr.setMemberID(rs.getInt("MemberID"));
                tr.setMemberName(rs.getString("MemberName"));
                tr.setStaffID(rs.getInt("StaffID"));
                list.add(tr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy giao dịch theo MemberID (dùng cho user xem lịch sử)
    public List<Transaction> getTransactionsByMember(int memberID) {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID
            FROM [Transaction] t
            WHERE t.MemberID = ?
            ORDER BY t.TransactionID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Transaction tr = new Transaction();
                tr.setTransactionID(rs.getInt("TransactionID"));
                tr.setBorrowDate(rs.getString("BorrowDate"));
                tr.setDueDate(rs.getString("DueDate"));
                tr.setReturnDate(rs.getString("ReturnDate"));
                tr.setStatus(rs.getString("Status"));
                tr.setMemberID(rs.getInt("MemberID"));
                tr.setStaffID(rs.getInt("StaffID"));
                list.add(tr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tạo phiếu mượn mới, trả về TransactionID vừa tạo
    public int createTransaction(int memberID, int staffID, String dueDate) {
        String sql = "INSERT INTO [Transaction] (DueDate, Status, MemberID, StaffID) "
                   + "OUTPUT INSERTED.TransactionID "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, dueDate);
            ps.setNString(2, "Đang mượn");
            ps.setInt(3, memberID);
            ps.setInt(4, staffID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.out.println("DEBUG createTransaction SQL error: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Thêm bản sao vào Transaction_Detail và cập nhật status Book_Copy
    public boolean addCopyToTransaction(int transactionID, int copyID) {
        try {
            PreparedStatement ps1 = connection.prepareStatement(
                "INSERT INTO Transaction_Detail (TransactionID, CopyID) VALUES (?, ?)");
            ps1.setInt(1, transactionID);
            ps1.setInt(2, copyID);
            ps1.executeUpdate();

            PreparedStatement ps2 = connection.prepareStatement(
                "UPDATE Book_Copy SET Status = N'Đã cho mượn' WHERE CopyID = ?");
            ps2.setInt(1, copyID);
            ps2.executeUpdate();

            PreparedStatement ps3 = connection.prepareStatement(
                "UPDATE Book SET AvailableQuantity = AvailableQuantity - 1 " +
                "WHERE ISBN = (SELECT ISBN FROM Book_Copy WHERE CopyID = ?) AND AvailableQuantity > 0");
            ps3.setInt(1, copyID);
            ps3.executeUpdate();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Trả sách: cập nhật Transaction + Book_Copy + Book.AvailableQuantity
    public boolean returnTransaction(int transactionID) {
        try {
            PreparedStatement ps0 = connection.prepareStatement(
                "UPDATE [Transaction] SET ReturnDate = GETDATE(), Status = N'Đã trả' " +
                "WHERE TransactionID = ? AND Status = N'Đang mượn'");
            ps0.setInt(1, transactionID);
            int rows = ps0.executeUpdate();
            if (rows == 0) return false;

            PreparedStatement ps1 = connection.prepareStatement(
                "SELECT CopyID FROM Transaction_Detail WHERE TransactionID = ?");
            ps1.setInt(1, transactionID);
            ResultSet rs = ps1.executeQuery();
            while (rs.next()) {
                int copyID = rs.getInt("CopyID");

                PreparedStatement ps2 = connection.prepareStatement(
                    "UPDATE Book_Copy SET Status = N'Trên kệ' WHERE CopyID = ?");
                ps2.setInt(1, copyID);
                ps2.executeUpdate();

                PreparedStatement ps3 = connection.prepareStatement(
                    "UPDATE Book SET AvailableQuantity = AvailableQuantity + 1 " +
                    "WHERE ISBN = (SELECT ISBN FROM Book_Copy WHERE CopyID = ?)");
                ps3.setInt(1, copyID);
                ps3.executeUpdate();
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy danh sách bản sao sách đang "Trên kệ" (để chọn khi mượn)
    public List<String[]> getAvailableCopies() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT bc.CopyID, bc.Barcode, b.Title, b.ISBN
            FROM Book_Copy bc
            JOIN Book b ON bc.ISBN = b.ISBN
            WHERE bc.Status = N'Trên kệ'
            ORDER BY b.Title
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("CopyID"),
                    rs.getString("Barcode"),
                    rs.getString("Title"),
                    rs.getString("ISBN")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tự động cập nhật phiếu quá hạn chưa trả → "Quá hạn"
    public void updateOverdue() {
        String sql = "UPDATE [Transaction] SET Status = N'Quá hạn' " +
                     "WHERE DueDate < CAST(GETDATE() AS DATE) AND Status = N'Đang mượn'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Lấy chi tiết sách trong một phiếu mượn
    public List<String[]> getTransactionDetails(int transactionID) {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT bc.CopyID, bc.Barcode, bc.Status AS CopyStatus,
                   b.Title, b.ISBN
            FROM Transaction_Detail td
            JOIN Book_Copy bc ON td.CopyID = bc.CopyID
            JOIN Book b ON bc.ISBN = b.ISBN
            WHERE td.TransactionID = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transactionID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("CopyID"),
                    rs.getString("Barcode"),
                    rs.getString("Title"),
                    rs.getString("ISBN"),
                    rs.getString("CopyStatus")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy thông tin một phiếu mượn theo ID
    public Transaction getTransactionByID(int transactionID) {
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID, m.FullName AS MemberName
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE t.TransactionID = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transactionID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Transaction tr = new Transaction();
                tr.setTransactionID(rs.getInt("TransactionID"));
                tr.setBorrowDate(rs.getString("BorrowDate"));
                tr.setDueDate(rs.getString("DueDate"));
                tr.setReturnDate(rs.getString("ReturnDate"));
                tr.setStatus(rs.getString("Status"));
                tr.setMemberID(rs.getInt("MemberID"));
                tr.setMemberName(rs.getString("MemberName"));
                tr.setStaffID(rs.getInt("StaffID"));
                return tr;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách thành viên
    public List<String[]> getActiveMembers() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT MemberID, FullName FROM Member ORDER BY FullName";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{ rs.getString("MemberID"), rs.getString("FullName") });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
}
