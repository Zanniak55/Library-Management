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
    // Lấy tất cả giao dịch kèm tên thành viên (có phân trang)
    public List<Transaction> getTransactions(int offset, int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID,
                   m.FullName AS MemberName
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            ORDER BY t.TransactionID DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
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

    public int getTotalTransactions() {
        String sql = "SELECT COUNT(*) FROM [Transaction]";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Transaction> searchTransactions(String keyword, String status, int offset, int limit) {
        List<Transaction> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, t.BorrowDate, t.DueDate, t.ReturnDate,
                   t.Status, t.MemberID, t.StaffID, m.FullName AS MemberName
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE (? = '' OR m.FullName LIKE ?)
              AND (? = '' OR t.Status = ?)
            ORDER BY t.TransactionID DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = keyword == null ? "" : keyword.trim();
            String st = status  == null ? "" : status.trim();
            ps.setString(1, kw);
            ps.setString(2, "%" + kw + "%");
            ps.setString(3, st);
            ps.setString(4, st);
            ps.setInt(5, offset);
            ps.setInt(6, limit);
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

    public int getTotalSearchTransactions(String keyword, String status) {
        String sql = """
            SELECT COUNT(*) FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE (? = '' OR m.FullName LIKE ?)
              AND (? = '' OR t.Status = ?)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = keyword == null ? "" : keyword.trim();
            String st = status  == null ? "" : status.trim();
            ps.setString(1, kw);
            ps.setString(2, "%" + kw + "%");
            ps.setString(3, st);
            ps.setString(4, st);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int[] getMemberLoanStats(int memberID) {
        int[] stats = new int[2];
        String sql = """
            SELECT
                SUM(CASE WHEN Status = N'Đang mượn' OR Status = N'Quá hạn' THEN 1 ELSE 0 END) AS ActiveLoans,
                COUNT(*) AS TotalLoans
            FROM [Transaction]
            WHERE MemberID = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt("ActiveLoans");
                    stats[1] = rs.getInt("TotalLoans");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
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
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            
            try (PreparedStatement ps1 = connection.prepareStatement(
                "INSERT INTO Transaction_Detail (TransactionID, CopyID) VALUES (?, ?)")) {
                ps1.setInt(1, transactionID);
                ps1.setInt(2, copyID);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = connection.prepareStatement(
                "UPDATE Book_Copy SET Status = N'Đã cho mượn' WHERE CopyID = ? AND Status = N'Trên kệ'")) {
                ps2.setInt(1, copyID);
                int updatedRows = ps2.executeUpdate();
                if (updatedRows == 0) {
                    connection.rollback();
                    return false; 
                }
            }

            try (PreparedStatement ps3 = connection.prepareStatement(
                "UPDATE Book SET AvailableQuantity = AvailableQuantity - 1 " +
                "WHERE ISBN = (SELECT ISBN FROM Book_Copy WHERE CopyID = ?) AND AvailableQuantity > 0")) {
                ps3.setInt(1, copyID);
                int updatedRows = ps3.executeUpdate();
                if (updatedRows == 0) {
                    connection.rollback();
                    return false; 
                }
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(originalAutoCommit); } catch(SQLException ex) {}
        }
        return false;
    }

    // Trả sách: cập nhật Transaction + Book_Copy + Book.AvailableQuantity
    public boolean returnTransaction(int transactionID) {
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

            try (PreparedStatement psCheck = connection.prepareStatement(
                "SELECT DATEDIFF(day, DueDate, CAST(GETDATE() AS DATE)) AS DaysLate " +
                "FROM [Transaction] WHERE TransactionID = ? AND DueDate < CAST(GETDATE() AS DATE) AND Status IN (N'Đang mượn', N'Quá hạn')")) {
                psCheck.setInt(1, transactionID);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        int daysLate = rsCheck.getInt("DaysLate");
                        if (daysLate > 0) {
                            double amount = daysLate * 5000.0;
                            String reason = "Trả sách muộn " + daysLate + " ngày (5,000đ/ngày)";
                            
                            boolean hasFine = false;
                            try (PreparedStatement psFineCheck = connection.prepareStatement("SELECT FineID FROM Fine WHERE TransactionID = ?")) {
                                psFineCheck.setInt(1, transactionID);
                                try (ResultSet rsFineCheck = psFineCheck.executeQuery()) {
                                    hasFine = rsFineCheck.next();
                                }
                            }
                            
                            if (hasFine) {
                                try (PreparedStatement psFineUpd = connection.prepareStatement("UPDATE Fine SET Amount = ?, Reason = ? WHERE TransactionID = ?")) {
                                    psFineUpd.setDouble(1, amount);
                                    psFineUpd.setString(2, reason);
                                    psFineUpd.setInt(3, transactionID);
                                    psFineUpd.executeUpdate();
                                }
                            } else {
                                try (PreparedStatement psFineIns = connection.prepareStatement("INSERT INTO Fine (TransactionID, Reason, Amount) VALUES (?, ?, ?)")) {
                                    psFineIns.setInt(1, transactionID);
                                    psFineIns.setString(2, reason);
                                    psFineIns.setDouble(3, amount);
                                    psFineIns.executeUpdate();
                                }
                            }
                        }
                    }
                }
            }

            try (PreparedStatement ps0 = connection.prepareStatement(
                "UPDATE [Transaction] SET ReturnDate = GETDATE(), Status = N'Đã trả' " +
                "WHERE TransactionID = ? AND Status IN (N'Đang mượn', N'Quá hạn')")) {
                ps0.setInt(1, transactionID);
                if (ps0.executeUpdate() == 0) {
                    connection.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps1 = connection.prepareStatement(
                "SELECT CopyID FROM Transaction_Detail WHERE TransactionID = ?")) {
                ps1.setInt(1, transactionID);
                try (ResultSet rs = ps1.executeQuery()) {
                    while (rs.next()) {
                        int copyID = rs.getInt("CopyID");

                        try (PreparedStatement ps2 = connection.prepareStatement(
                            "UPDATE Book_Copy SET Status = N'Trên kệ' WHERE CopyID = ? AND Status = N'Đã cho mượn'")) {
                            ps2.setInt(1, copyID);
                            if (ps2.executeUpdate() > 0) {
                                try (PreparedStatement ps3 = connection.prepareStatement(
                                    "UPDATE Book SET AvailableQuantity = AvailableQuantity + 1 " +
                                    "WHERE ISBN = (SELECT ISBN FROM Book_Copy WHERE CopyID = ?)")) {
                                    ps3.setInt(1, copyID);
                                    ps3.executeUpdate();
                                }
                            }
                        }
                    }
                }
            }
            
            connection.commit();
            return true;
        } catch (SQLException e) {
            try { connection.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(originalAutoCommit); } catch(SQLException ex) {}
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

    // Lấy thống kê tổng quan
    public int[] getLoanOverviewStats() {
        int[] stats = new int[3]; // [Đang mượn, Đã trả, Quá hạn]
        String sql = "SELECT Status, COUNT(*) FROM [Transaction] GROUP BY Status";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString(1);
                int count = rs.getInt(2);
                if ("Đang mượn".equals(status)) stats[0] = count;
                else if ("Đã trả".equals(status)) stats[1] = count;
                else if ("Quá hạn".equals(status)) stats[2] = count;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // Lấy top 5 sách mượn nhiều nhất
    public List<String[]> getTopBorrowedBooks() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT TOP 5 b.Title, COUNT(td.TransactionID) AS BorrowCount
            FROM Transaction_Detail td
            JOIN Book_Copy bc ON td.CopyID = bc.CopyID
            JOIN Book b ON bc.ISBN = b.ISBN
            GROUP BY b.ISBN, b.Title
            ORDER BY BorrowCount DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{ rs.getString("Title"), rs.getString("BorrowCount") });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy thống kê mượn/trả theo tháng (12 tháng gần nhất)
    public List<String[]> getMonthlyLoanStats() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT FORMAT(BorrowDate, 'MM/yyyy') AS Month,
                   COUNT(TransactionID) AS TotalBorrowed,
                   SUM(CASE WHEN Status = N'Đã trả' THEN 1 ELSE 0 END) AS TotalReturned
            FROM [Transaction]
            WHERE BorrowDate >= DATEADD(MONTH, -11, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
            GROUP BY FORMAT(BorrowDate, 'MM/yyyy'), YEAR(BorrowDate), MONTH(BorrowDate)
            ORDER BY YEAR(BorrowDate), MONTH(BorrowDate)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("Month"),
                    rs.getString("TotalBorrowed"),
                    rs.getString("TotalReturned")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
