package dao;

import java.sql.*;

public class DashboardDAO extends DBContext {

    public int count(String sql) {
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalMembers() {
        return count("SELECT COUNT(*) FROM Member");
    }

    public int getActiveMembers() {
        return count("SELECT COUNT(*) FROM Member WHERE Status != N'Bị khóa'");
    }

    public int getTotalStaff() {
        return count("SELECT COUNT(*) FROM Staff");
    }

    public int getTotalBooks() {
        return count("SELECT COUNT(*) FROM Book");
    }

    public int getBorrowingNow() {
        return count("SELECT COUNT(*) FROM [Transaction] WHERE Status = N'Đang mượn'");
    }

    public java.util.List<String[]> getMonthlyBorrows() {
        java.util.List<String[]> list = new java.util.ArrayList<>();
        String sql = """
            SELECT FORMAT(BorrowDate, 'MM/yyyy') AS Month, COUNT(*) AS Total
            FROM [Transaction]
            WHERE BorrowDate >= DATEADD(MONTH, -5, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
            GROUP BY FORMAT(BorrowDate, 'MM/yyyy'), YEAR(BorrowDate), MONTH(BorrowDate)
            ORDER BY YEAR(BorrowDate), MONTH(BorrowDate)
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new String[]{ rs.getString("Month"), rs.getString("Total") });
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public java.util.List<String[]> getTopBooks() {
        java.util.List<String[]> list = new java.util.ArrayList<>();
        String sql = """
            SELECT TOP 5 b.Title, COUNT(td.CopyID) AS BorrowCount
            FROM Transaction_Detail td
            JOIN Book_Copy bc ON td.CopyID = bc.CopyID
            JOIN Book b ON bc.ISBN = b.ISBN
            GROUP BY b.ISBN, b.Title
            ORDER BY BorrowCount DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(new String[]{ rs.getString("Title"), rs.getString("BorrowCount") });
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
