package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Publisher;

public class PublisherDAO extends DBContext {

    public List<Publisher> getPublishers(int offset, int limit) {
        List<Publisher> list = new ArrayList<>();
        String sql = "SELECT PublisherID, PublisherName, Address, Phone, Email FROM Publisher ORDER BY PublisherName "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Publisher(
                            rs.getInt("PublisherID"),
                            rs.getString("PublisherName"),
                            rs.getString("Address"),
                            rs.getString("Phone"),
                            rs.getString("Email")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalPublishers() {
        String sql = "SELECT COUNT(*) FROM Publisher";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Publisher> searchPublishers(String keyword, int offset, int limit) {
        List<Publisher> list = new ArrayList<>();
        String sql = "SELECT PublisherID, PublisherName, Address, Phone, Email FROM Publisher "
                   + "WHERE PublisherName LIKE ? OR Email LIKE ? OR Phone LIKE ? "
                   + "ORDER BY PublisherName "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Publisher(
                            rs.getInt("PublisherID"),
                            rs.getString("PublisherName"),
                            rs.getString("Address"),
                            rs.getString("Phone"),
                            rs.getString("Email")
                    ));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalSearchPublishers(String keyword) {
        String sql = "SELECT COUNT(*) FROM Publisher "
                   + "WHERE PublisherName LIKE ? OR Email LIKE ? OR Phone LIKE ?";
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Publisher getPublisherByID(int id) {
        String sql = "SELECT PublisherID, PublisherName, Address, Phone, Email FROM Publisher WHERE PublisherID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Publisher(
                            rs.getInt("PublisherID"),
                            rs.getString("PublisherName"),
                            rs.getString("Address"),
                            rs.getString("Phone"),
                            rs.getString("Email")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertPublisher(Publisher p) {
        String sql = "INSERT INTO Publisher (PublisherName, Address, Phone, Email) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, p.getPublisherName());
            ps.setNString(2, p.getAddress());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePublisher(Publisher p) {
        String sql = "UPDATE Publisher SET PublisherName = ?, Address = ?, Phone = ?, Email = ? WHERE PublisherID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, p.getPublisherName());
            ps.setNString(2, p.getAddress());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getEmail());
            ps.setInt(5, p.getPublisherID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePublisher(int id) {
        // Cần đảm bảo nếu xoá NXB thì các Book liên quan có thể bị lỗi khoá ngoại.
        // Chú ý: Ở đây ta set null cho Book.PublisherID trước (nếu DB không cấu hình ON DELETE SET NULL).
        String updateBooks = "UPDATE Book SET PublisherID = NULL WHERE PublisherID = ?";
        try (PreparedStatement psBook = connection.prepareStatement(updateBooks)) {
            psBook.setInt(1, id);
            psBook.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        String sql = "DELETE FROM Publisher WHERE PublisherID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
