package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Reservation;

public class ReservationDAO extends DBContext {

    public boolean createReservation(int memberID, String isbn) {
        String sql = "INSERT INTO Reservation (MemberID, ISBN) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            ps.setString(2, isbn);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Reservation> getReservationsByMember(int memberID) {
        List<Reservation> list = new ArrayList<>();
        String sql = """
            SELECT r.ReservationID, r.MemberID, r.ISBN, r.ReservationDate, r.Status, b.Title
            FROM Reservation r
            JOIN Book b ON r.ISBN = b.ISBN
            WHERE r.MemberID = ?
            ORDER BY r.ReservationID DESC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, memberID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setReservationID(rs.getInt("ReservationID"));
                    r.setMemberID(rs.getInt("MemberID"));
                    r.setIsbn(rs.getString("ISBN"));
                    r.setReservationDate(rs.getString("ReservationDate"));
                    r.setStatus(rs.getString("Status"));
                    r.setBookTitle(rs.getString("Title"));
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Reservation> getAllPendingReservations() {
        List<Reservation> list = new ArrayList<>();
        String sql = """
            SELECT r.ReservationID, r.MemberID, r.ISBN, r.ReservationDate, r.Status,
                   b.Title, m.FullName
            FROM Reservation r
            JOIN Book b ON r.ISBN = b.ISBN
            JOIN Member m ON r.MemberID = m.MemberID
            WHERE r.Status = N'Chờ duyệt'
            ORDER BY r.ReservationID ASC
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setReservationID(rs.getInt("ReservationID"));
                r.setMemberID(rs.getInt("MemberID"));
                r.setIsbn(rs.getString("ISBN"));
                r.setReservationDate(rs.getString("ReservationDate"));
                r.setStatus(rs.getString("Status"));
                r.setBookTitle(rs.getString("Title"));
                r.setMemberName(rs.getString("FullName"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateReservationStatus(int reservationID, String status) {
        String sql = "UPDATE Reservation SET Status = ? WHERE ReservationID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, reservationID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean approveReservation(int reservationID) {
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);
            
            String isbn = null;
            try (PreparedStatement ps1 = connection.prepareStatement("SELECT ISBN FROM Reservation WHERE ReservationID = ?")) {
                ps1.setInt(1, reservationID);
                try (ResultSet rs = ps1.executeQuery()) {
                    if (rs.next()) isbn = rs.getString("ISBN");
                }
            }
            if (isbn == null) { connection.rollback(); return false; }
            
            try (PreparedStatement ps2 = connection.prepareStatement("UPDATE Book SET AvailableQuantity = AvailableQuantity - 1 WHERE ISBN = ? AND AvailableQuantity > 0")) {
                ps2.setString(1, isbn);
                if (ps2.executeUpdate() == 0) {
                    connection.rollback();
                    return false; 
                }
            }
            
            try (PreparedStatement ps3 = connection.prepareStatement("UPDATE Reservation SET Status = N'Đã duyệt' WHERE ReservationID = ?")) {
                ps3.setInt(1, reservationID);
                ps3.executeUpdate();
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
}
