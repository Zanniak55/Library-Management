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
}
