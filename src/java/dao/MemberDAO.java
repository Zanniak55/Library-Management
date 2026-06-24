package dao;

import model.Member;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class MemberDAO extends DBContext {
    public List<Member> getAllMembers() {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT MemberID, FullName, Phone, Email, Address, "
                + "MemberType, MembershipDate, Status, Username "
                + "FROM Member "
                + "ORDER BY MemberID";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs, false));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public Member getMemberByID(int memberID) {
        String sql = "SELECT MemberID, FullName, Phone, Email, Address, "
                + "MemberType, MembershipDate, Status, Username "
                + "FROM Member WHERE MemberID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, false);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Member getMemberByUsername(String username) {
        String sql = "SELECT MemberID, FullName, Phone, Email, Address, "
                + "MemberType, MembershipDate, Status, Username, Password "
                + "FROM Member WHERE Username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs, true);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<Member> searchMembers(String keyword) {
        List<Member> list = new ArrayList<>();
        String sql = "SELECT MemberID, FullName, Phone, Email, Address, "
                + "MemberType, MembershipDate, Status, Username "
                + "FROM Member "
                + "WHERE FullName LIKE ? OR Email LIKE ? OR Username LIKE ? "
                + "ORDER BY MemberID";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs, false));
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean addMember(Member m) {
        String sql = "INSERT INTO Member "
                + "(FullName, Phone, Email, Address, MemberType, MembershipDate, Status, Username, Password) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getAddress());
            ps.setString(5, m.getMemberType());
            ps.setString(6, m.getMembershipDate());
            ps.setString(7, m.getStatus());
            ps.setString(8, nullIfEmpty(m.getUsername()));
            ps.setString(9, nullIfEmpty(m.getPassword()));
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateMember(Member m) {
        String sql;
        if (m.getPassword() != null && !m.getPassword().isEmpty()) {
            sql = "UPDATE Member SET FullName=?, Phone=?, Email=?, Address=?, "
                    + "MemberType=?, MembershipDate=?, Status=?, Username=?, Password=? "
                    + "WHERE MemberID=?";
        } else {
            sql = "UPDATE Member SET FullName=?, Phone=?, Email=?, Address=?, "
                    + "MemberType=?, MembershipDate=?, Status=?, Username=? "
                    + "WHERE MemberID=?";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, m.getFullName());
            ps.setString(2, m.getPhone());
            ps.setString(3, m.getEmail());
            ps.setString(4, m.getAddress());
            ps.setString(5, m.getMemberType());
            ps.setString(6, m.getMembershipDate());
            ps.setString(7, m.getStatus());
            ps.setString(8, nullIfEmpty(m.getUsername()));

            if (m.getPassword() != null && !m.getPassword().isEmpty()) {
                ps.setString(9, m.getPassword());
                ps.setInt(10, m.getMemberID());
            } else {
                ps.setInt(9, m.getMemberID());
            }

            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteMember(int memberID) {
        String sql = "DELETE FROM Member WHERE MemberID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MemberDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    private Member mapRow(ResultSet rs, boolean includePassword) throws SQLException {
        Member m = new Member();
        m.setMemberID(rs.getInt("MemberID"));
        m.setFullName(rs.getString("FullName"));
        m.setPhone(rs.getString("Phone"));
        m.setEmail(rs.getString("Email"));
        m.setAddress(rs.getString("Address"));
        m.setMemberType(rs.getString("MemberType"));
        if (rs.getDate("MembershipDate") != null) {
            m.setMembershipDate(rs.getDate("MembershipDate").toString());
        }
        m.setStatus(rs.getString("Status"));
        m.setUsername(rs.getString("Username"));
        if (includePassword) {
            m.setPassword(rs.getString("Password"));
        }
        return m;
    }

    private String nullIfEmpty(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}
