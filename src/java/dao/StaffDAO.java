package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Staff;

public class StaffDAO extends DBContext {

    public Staff login(String email, String password) {
        String sql = "SELECT * FROM Staff WHERE Email = ? AND Password = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, e);
        }
        return null;
    }

    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT StaffID, FullName, Email, Role FROM Staff ORDER BY StaffID";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Staff getStaffByID(int staffID) {
        String sql = "SELECT StaffID, FullName, Email, Role FROM Staff WHERE StaffID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean addStaff(Staff s) {
        String sql = "INSERT INTO Staff (FullName, Email, Password, Role) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getPassword());
            ps.setString(4, s.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateStaff(Staff s) {
        String sql;
        if (s.getPassword() != null && !s.getPassword().isEmpty()) {
            sql = "UPDATE Staff SET FullName=?, Email=?, Password=?, Role=? WHERE StaffID=?";
        } else {
            sql = "UPDATE Staff SET FullName=?, Email=?, Role=? WHERE StaffID=?";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, s.getFullName());
            ps.setString(2, s.getEmail());
            if (s.getPassword() != null && !s.getPassword().isEmpty()) {
                ps.setString(3, s.getPassword());
                ps.setString(4, s.getRole());
                ps.setInt(5, s.getStaffID());
            } else {
                ps.setString(3, s.getRole());
                ps.setInt(4, s.getStaffID());
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteStaff(int staffID) {
        String sql = "DELETE FROM Staff WHERE StaffID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, staffID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(StaffDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    private Staff mapRow(ResultSet rs) throws SQLException {
        Staff s = new Staff();
        s.setStaffID(rs.getInt("StaffID"));
        s.setFullName(rs.getString("FullName"));
        s.setEmail(rs.getString("Email"));
        s.setRole(rs.getString("Role"));
        try {
            s.setPassword(rs.getString("Password"));
        } catch (SQLException ignored) {
        }
        return s;
    }
}
