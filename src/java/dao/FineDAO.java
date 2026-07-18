package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Fine;

public class FineDAO extends DBContext {

    // Lấy tất cả phiếu phạt kèm tên thành viên
    public List<Fine> getAllFines(String keyword, String paidStatus, int offset, int limit) {
        List<Fine> list = new ArrayList<>();
        String sql = """
            SELECT f.FineID, f.TransactionID, f.Reason, f.Amount,
                   f.IssueDate, f.PaidDate, f.PaidStatus,
                   m.FullName AS MemberName,
                   t.BorrowDate, t.DueDate
            FROM Fine f
            JOIN [Transaction] t ON f.TransactionID = t.TransactionID
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE (? = '' OR m.FullName LIKE ?)
              AND (? = '' OR f.PaidStatus = ?)
            ORDER BY f.FineID DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = keyword == null ? "" : keyword.trim();
            String st = paidStatus == null ? "" : paidStatus.trim();
            ps.setString(1, kw);
            ps.setString(2, "%" + kw + "%");
            ps.setString(3, st);
            ps.setString(4, st);
            ps.setInt(5, offset);
            ps.setInt(6, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Fine f = new Fine();
                f.setFineID(rs.getInt("FineID"));
                f.setTransactionID(rs.getInt("TransactionID"));
                f.setReason(rs.getString("Reason"));
                f.setAmount(rs.getDouble("Amount"));
                f.setIssueDate(rs.getString("IssueDate"));
                f.setPaidDate(rs.getString("PaidDate"));
                f.setPaidStatus(rs.getString("PaidStatus"));
                f.setMemberName(rs.getString("MemberName"));
                f.setBorrowDate(rs.getString("BorrowDate"));
                f.setDueDate(rs.getString("DueDate"));
                list.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalFines(String keyword, String paidStatus) {
        String sql = """
            SELECT COUNT(*)
            FROM Fine f
            JOIN [Transaction] t ON f.TransactionID = t.TransactionID
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE (? = '' OR m.FullName LIKE ?)
              AND (? = '' OR f.PaidStatus = ?)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String kw = keyword == null ? "" : keyword.trim();
            String st = paidStatus == null ? "" : paidStatus.trim();
            ps.setString(1, kw);
            ps.setString(2, "%" + kw + "%");
            ps.setString(3, st);
            ps.setString(4, st);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tạo phiếu phạt mới (thủ công)
    public boolean createFine(int transactionID, String reason, double amount) {
        String sql = "INSERT INTO Fine (TransactionID, Reason, Amount) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, transactionID);
            ps.setNString(2, reason);
            ps.setDouble(3, amount);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đánh dấu đã thanh toán
    public boolean markPaid(int fineID) {
        String sql = "UPDATE Fine SET PaidStatus = N'Đã đóng', PaidDate = CAST(GETDATE() AS DATE) WHERE FineID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, fineID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tự động tạo phiếu phạt cho các phiếu quá hạn chưa có phiếu phạt
    // Mức phạt: 5.000đ/ngày
    public void autoCreateOverdueFines() {
        String sql = """
            INSERT INTO Fine (TransactionID, Reason, Amount)
            SELECT t.TransactionID,
                   N'Trả sách muộn ' + CAST(DATEDIFF(day, t.DueDate, CAST(GETDATE() AS DATE)) AS NVARCHAR)
                   + N' ngày (5,000đ/ngày)',
                   DATEDIFF(day, t.DueDate, CAST(GETDATE() AS DATE)) * 5000.0
            FROM [Transaction] t
            WHERE t.Status = N'Quá hạn'
              AND NOT EXISTS (SELECT 1 FROM Fine f WHERE f.TransactionID = t.TransactionID
                              AND f.Reason LIKE N'Trả sách muộn%')
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Tổng tiền đã thu
    public double getTotalPaid() {
        String sql = "SELECT ISNULL(SUM(Amount), 0) FROM Fine WHERE PaidStatus = N'Đã đóng'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng tiền phạt chưa đóng
    public double getTotalUnpaid() {
        String sql = "SELECT ISNULL(SUM(Amount), 0) FROM Fine WHERE PaidStatus = N'Chưa đóng'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Thống kê tiền thu theo tháng (12 tháng gần nhất)
    public List<String[]> getMonthlyStats() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT FORMAT(IssueDate, 'MM/yyyy') AS Month,
                   ISNULL(SUM(CASE WHEN PaidStatus = N'Đã đóng' THEN Amount ELSE 0 END), 0) AS Paid,
                   ISNULL(SUM(CASE WHEN PaidStatus = N'Chưa đóng' THEN Amount ELSE 0 END), 0) AS Unpaid
            FROM Fine
            WHERE IssueDate >= DATEADD(MONTH, -11, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
            GROUP BY FORMAT(IssueDate, 'MM/yyyy'), YEAR(IssueDate), MONTH(IssueDate)
            ORDER BY YEAR(IssueDate), MONTH(IssueDate)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("Month"),
                    rs.getString("Paid"),
                    rs.getString("Unpaid")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Top 5 thành viên bị phạt nhiều nhất
    public List<String[]> getTopFineMembers() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT TOP 5 m.FullName,
                   COUNT(f.FineID) AS FineCount,
                   SUM(f.Amount) AS TotalAmount
            FROM Fine f
            JOIN [Transaction] t ON f.TransactionID = t.TransactionID
            JOIN Member m ON t.MemberID = m.MemberID
            GROUP BY m.MemberID, m.FullName
            ORDER BY TotalAmount DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("FullName"),
                    rs.getString("FineCount"),
                    rs.getString("TotalAmount")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách phiếu mượn để tạo phiếu phạt thủ công
    public List<String[]> getTransactionsForFine() {
        List<String[]> list = new ArrayList<>();
        String sql = """
            SELECT t.TransactionID, m.FullName, t.BorrowDate, t.DueDate, t.Status
            FROM [Transaction] t
            JOIN Member m ON t.MemberID = m.MemberID
            ORDER BY t.TransactionID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{
                    rs.getString("TransactionID"),
                    rs.getString("FullName"),
                    rs.getString("BorrowDate"),
                    rs.getString("DueDate"),
                    rs.getString("Status")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Fine> getFinesByMember(int memberID) {
        List<Fine> list = new ArrayList<>();
        String sql = """
            SELECT f.FineID, f.TransactionID, f.Reason, f.Amount,
                   f.IssueDate, f.PaidDate, f.PaidStatus,
                   m.FullName as MemberName, t.BorrowDate, t.DueDate
            FROM Fine f
            JOIN [Transaction] t ON f.TransactionID = t.TransactionID
            JOIN Member m ON t.MemberID = m.MemberID
            WHERE t.MemberID = ?
            ORDER BY f.FineID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Fine f = new Fine();
                    f.setFineID(rs.getInt("FineID"));
                    f.setTransactionID(rs.getInt("TransactionID"));
                    f.setReason(rs.getString("Reason"));
                    f.setAmount(rs.getDouble("Amount"));
                    f.setIssueDate(rs.getDate("IssueDate") != null ? rs.getDate("IssueDate").toString() : null);
                    f.setPaidDate(rs.getDate("PaidDate") != null ? rs.getDate("PaidDate").toString() : null);
                    f.setPaidStatus(rs.getString("PaidStatus"));
                    f.setMemberName(rs.getString("MemberName"));
                    f.setBorrowDate(rs.getDate("BorrowDate") != null ? rs.getDate("BorrowDate").toString() : null);
                    f.setDueDate(rs.getDate("DueDate") != null ? rs.getDate("DueDate").toString() : null);
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
