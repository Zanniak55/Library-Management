/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.*;
import dao.DBContext;
import java.util.ArrayList;
import java.util.List;
import model.Bookcopy;

/**
 *
 * @author AAA
 */
public class BookcopyDAO extends DBContext {

    // ─── Lấy tất cả bản sao (JOIN Book để lấy tên sách) ─────────────────────
    public List<Bookcopy> getCopies(int offset, int limit) {
        List<Bookcopy> list = new ArrayList<>();
        String sql
                = "SELECT bc.CopyID, bc.Barcode, bc.CopyNumber, bc.Condition, "
                + "       bc.Status, bc.ShelfLocation, bc.ISBN, b.Title AS BookTitle "
                + "FROM Book_Copy bc "
                + "JOIN Book b ON bc.ISBN = b.ISBN "
                + "ORDER BY bc.ISBN, bc.CopyNumber "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalCopies() {
        String sql = "SELECT COUNT(*) FROM Book_Copy";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ─── Lấy bản sao theo ISBN ───────────────────────────────────────────────
    public List<Bookcopy> getCopiesByISBN(String isbn) {
        List<Bookcopy> list = new ArrayList<>();
        String sql
                = "SELECT bc.CopyID, bc.Barcode, bc.CopyNumber, bc.Condition, "
                + "       bc.Status, bc.ShelfLocation, bc.ISBN, b.Title AS BookTitle "
                + "FROM Book_Copy bc "
                + "JOIN Book b ON bc.ISBN = b.ISBN "
                + "WHERE bc.ISBN = ? "
                + "ORDER BY bc.CopyNumber";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Lấy bản sao theo CopyID ─────────────────────────────────────────────
    public Bookcopy getCopyByID(int copyID) {
        String sql
                = "SELECT bc.CopyID, bc.Barcode, bc.CopyNumber, bc.Condition, "
                + "       bc.Status, bc.ShelfLocation, bc.ISBN, b.Title AS BookTitle "
                + "FROM Book_Copy bc "
                + "JOIN Book b ON bc.ISBN = b.ISBN "
                + "WHERE bc.CopyID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, copyID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── Tìm kiếm theo tên sách / barcode / vị trí ───────────────────────────
    public List<Bookcopy> searchCopies(String keyword, int offset, int limit) {
        List<Bookcopy> list = new ArrayList<>();
        String sql
                = "SELECT bc.CopyID, bc.Barcode, bc.CopyNumber, bc.Condition, "
                + "       bc.Status, bc.ShelfLocation, bc.ISBN, b.Title AS BookTitle "
                + "FROM Book_Copy bc "
                + "JOIN Book b ON bc.ISBN = b.ISBN "
                + "WHERE b.Title LIKE ? OR bc.Barcode LIKE ? OR bc.ShelfLocation LIKE ? "
                + "ORDER BY bc.ISBN, bc.CopyNumber "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ps.setInt(4, offset);
            ps.setInt(5, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalSearchCopies(String keyword) {
        String sql = "SELECT COUNT(*) FROM Book_Copy bc "
                   + "JOIN Book b ON bc.ISBN = b.ISBN "
                   + "WHERE b.Title LIKE ? OR bc.Barcode LIKE ? OR bc.ShelfLocation LIKE ?";
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, kw);
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

    // ─── Thêm bản sao ────────────────────────────────────────────────────────
    public boolean addCopy(Bookcopy copy) {
        // Tự tính CopyNumber tiếp theo cho ISBN này
        int nextNum = getNextCopyNumber(copy.getIsbn());
        String sql
                = "INSERT INTO Book_Copy (Barcode, CopyNumber, Condition, Status, ShelfLocation, ISBN) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, copy.getBarcode());
            ps.setInt(2, nextNum);
            ps.setNString(3, copy.getCondition());
            ps.setNString(4, copy.getStatus());
            ps.setNString(5, copy.getShelfLocation());
            ps.setString(6, copy.getIsbn());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Cập nhật bản sao ────────────────────────────────────────────────────
    public boolean updateCopy(Bookcopy copy) {
        String sql
                = "UPDATE Book_Copy SET Condition=?, Status=?, ShelfLocation=? "
                + "WHERE CopyID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, copy.getCondition());
            ps.setNString(2, copy.getStatus());
            ps.setNString(3, copy.getShelfLocation());
            ps.setInt(4, copy.getCopyID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Xóa bản sao ─────────────────────────────────────────────────────────
    public boolean deleteCopy(int copyID) {
        // Xóa Transaction_Detail trước (FK)
        String delDetail = "DELETE FROM Transaction_Detail WHERE CopyID = ?";
        try (PreparedStatement ps = connection.prepareStatement(delDetail)) {
            ps.setInt(1, copyID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        String sql = "DELETE FROM Book_Copy WHERE CopyID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, copyID);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Kiểm tra barcode đã tồn tại chưa ────────────────────────────────────
    public boolean isBarcodeExist(String barcode) {
        String sql = "SELECT COUNT(*) FROM Book_Copy WHERE Barcode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, barcode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ─── Lấy danh sách Book để dùng trong form dropdown ──────────────────────
    public List<String[]> getAllBooks() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT ISBN, Title FROM Book ORDER BY Title";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{rs.getString("ISBN"), rs.getString("Title")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Helper: CopyNumber tiếp theo cho 1 ISBN ──────────────────────────────
    private int getNextCopyNumber(String isbn) {
        String sql = "SELECT ISNULL(MAX(CopyNumber), 0) + 1 FROM Book_Copy WHERE ISBN = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 1;
    }

    // ─── Helper: ResultSet → BookCopy ────────────────────────────────────────
    private Bookcopy mapRow(ResultSet rs) throws SQLException {
        Bookcopy bc = new Bookcopy();
        bc.setCopyID(rs.getInt("CopyID"));
        bc.setBarcode(rs.getString("Barcode"));
        bc.setCopyNumber(rs.getInt("CopyNumber"));
        bc.setCondition(rs.getString("Condition"));
        bc.setStatus(rs.getString("Status"));
        bc.setShelfLocation(rs.getString("ShelfLocation"));
        bc.setIsbn(rs.getString("ISBN"));
        bc.setBookTitle(rs.getString("BookTitle"));
        return bc;
    }

    // Tự động tạo bản sao khi thêm sách mới
    public void autoCreateCopies(String isbn, int quantity, String shelfLocation) {
        String sql
                = "INSERT INTO Book_Copy (Barcode, CopyNumber, Condition, Status, ShelfLocation, ISBN) "
                + "VALUES (?, ?, N'Mới', N'Trên kệ', ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 1; i <= quantity; i++) {
                String barcode = "BC-" + isbn.replaceAll("[^0-9]", "").substring(0, 6) + "-" + String.format("%02d", i);
                ps.setString(1, barcode);
                ps.setInt(2, i);
                ps.setNString(3, shelfLocation.isEmpty() ? "Chưa xếp" : shelfLocation);
                ps.setString(4, isbn);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
