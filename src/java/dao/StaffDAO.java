package dao;


import java.sql.*;
import model.Staff;

public class StaffDAO extends DBContext {

    // Đăng nhập: tìm staff theo email + password
    public Staff login(String email, String password) {
        String sql = "SELECT * FROM Staff WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Staff s = new Staff();
                s.setStaffID(rs.getInt("StaffID"));
                s.setFullName(rs.getString("FullName"));
                s.setEmail(rs.getString("Email"));
                s.setPassword(rs.getString("Password"));
                s.setRole(rs.getString("Role"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
