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
import model.Book;

/**
 *
 * @author AAA
 */
public class BookDAO extends DBContext {

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.ISBN, b.Title, b.Language, b.PublicationYear,
                   b.TotalQuantity, b.AvailableQuantity,
                   c.CategoryName, p.PublisherName,
                   STRING_AGG(a.FullName, ', ') AS Authors
            FROM Book b
            LEFT JOIN Category    c ON b.CategoryID   = c.CategoryID
            LEFT JOIN Publisher   p ON b.PublisherID  = p.PublisherID
            LEFT JOIN Book_Author ba ON b.ISBN         = ba.ISBN
            LEFT JOIN Author      a ON ba.AuthorID     = a.AuthorID
            GROUP BY b.ISBN, b.Title, b.Language, b.PublicationYear,
                     b.TotalQuantity, b.AvailableQuantity,
                     c.CategoryName, p.PublisherName
            ORDER BY b.Title
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                books.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // ─── Lấy sách theo ISBN ──────────────────────────────────────────────────
    public Book getBookByISBN(String isbn) {
        String sql = """
            SELECT b.ISBN, b.Title, b.Language, b.PublicationYear,
                   b.TotalQuantity, b.AvailableQuantity,
                   c.CategoryName, p.PublisherName,
                   STRING_AGG(a.FullName, ', ') AS Authors
            FROM Book b
            LEFT JOIN Category    c ON b.CategoryID  = c.CategoryID
            LEFT JOIN Publisher   p ON b.PublisherID = p.PublisherID
            LEFT JOIN Book_Author ba ON b.ISBN        = ba.ISBN
            LEFT JOIN Author      a ON ba.AuthorID    = a.AuthorID
            WHERE b.ISBN = ?
            GROUP BY b.ISBN, b.Title, b.Language, b.PublicationYear,
                     b.TotalQuantity, b.AvailableQuantity,
                     c.CategoryName, p.PublisherName
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
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

    // ─── Tìm kiếm theo tên / tác giả / ISBN ─────────────────────────────────
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = """
            SELECT b.ISBN, b.Title, b.Language, b.PublicationYear,
                   b.TotalQuantity, b.AvailableQuantity,
                   c.CategoryName, p.PublisherName,
                   STRING_AGG(a.FullName, ', ') AS Authors
            FROM Book b
            LEFT JOIN Category    c ON b.CategoryID  = c.CategoryID
            LEFT JOIN Publisher   p ON b.PublisherID = p.PublisherID
            LEFT JOIN Book_Author ba ON b.ISBN        = ba.ISBN
            LEFT JOIN Author      a ON ba.AuthorID    = a.AuthorID
            WHERE b.Title LIKE ? OR a.FullName LIKE ? OR b.ISBN LIKE ?
            GROUP BY b.ISBN, b.Title, b.Language, b.PublicationYear,
                     b.TotalQuantity, b.AvailableQuantity,
                     c.CategoryName, p.PublisherName
            ORDER BY b.Title
            """;
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    books.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // ─── Thêm sách ───────────────────────────────────────────────────────────
    public boolean addBook(Book book) {
        String sql
                = "INSERT INTO Book (ISBN, Title, Language, PublicationYear, "
                + "                  TotalQuantity, AvailableQuantity, PublisherID, CategoryID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, book.getIsbn());
            ps.setNString(2, book.getTitle());
            ps.setNString(3, book.getLanguage());
            ps.setInt(4, book.getPublicationYear());
            ps.setInt(5, book.getTotalQuantity());
            ps.setInt(6, book.getAvailableQuantity());
            if (book.getPublisherID() > 0) {
                ps.setInt(7, book.getPublisherID());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            if (book.getCategoryID() > 0) {
                ps.setInt(8, book.getCategoryID());
            } else {
                ps.setNull(8, java.sql.Types.INTEGER);
            }

            boolean ok = ps.executeUpdate() > 0;
            // Lưu tác giả vào Book_Author
            if (ok && book.getAuthorID() > 0) {
                addBookAuthor(book.getIsbn(), book.getAuthorID());
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Cập nhật sách ───────────────────────────────────────────────────────
    public boolean updateBook(Book book) {
        String sql = """
            UPDATE Book SET Title=?, Language=?, PublicationYear=?,
                            TotalQuantity=?, AvailableQuantity=?,
                            PublisherID=?, CategoryID=?
            WHERE ISBN=?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getLanguage());
            ps.setInt(3, book.getPublicationYear());
            ps.setInt(4, book.getTotalQuantity());
            ps.setInt(5, book.getAvailableQuantity());
            ps.setInt(6, book.getPublisherID());
            ps.setInt(7, book.getCategoryID());
            ps.setString(8, book.getIsbn());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Xóa sách ────────────────────────────────────────────────────────────
    public boolean deleteBook(String isbn) {
        String sql = "DELETE FROM Book WHERE ISBN = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Cập nhật số lượng khi mượn / trả ───────────────────────────────────
    // delta = -1 khi mượn, +1 khi trả
    public boolean updateAvailable(String isbn, int delta) {
        String sql = """
            UPDATE Book SET AvailableQuantity = AvailableQuantity + ?
            WHERE ISBN = ? AND (AvailableQuantity + ?) >= 0
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setString(2, isbn);
            ps.setInt(3, delta);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Lấy danh sách Category để dùng trong form ───────────────────────────
    public List<String[]> getAllCategories() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName FROM Category ORDER BY CategoryName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{rs.getString("CategoryID"), rs.getString("CategoryName")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Lấy danh sách Publisher để dùng trong form ──────────────────────────
    public List<String[]> getAllPublishers() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT PublisherID, PublisherName FROM Publisher ORDER BY PublisherName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{rs.getString("PublisherID"), rs.getString("PublisherName")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─── Helper: ResultSet → Book ─────────────────────────────────────────────
    private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setIsbn(rs.getString("ISBN"));
        b.setTitle(rs.getString("Title"));
        b.setLanguage(rs.getString("Language"));
        b.setPublicationYear(rs.getInt("PublicationYear"));
        b.setTotalQuantity(rs.getInt("TotalQuantity"));
        b.setAvailableQuantity(rs.getInt("AvailableQuantity"));
        b.setCategoryName(rs.getString("CategoryName"));
        b.setPublisherName(rs.getString("PublisherName"));
        b.setAuthors(rs.getString("Authors"));
        return b;
    }

    // ─── Helper: set params cho addBook ──────────────────────────────────────
    private void setParams(PreparedStatement ps, Book book) throws SQLException {
        ps.setString(1, book.getIsbn());
        ps.setString(2, book.getTitle());
        ps.setString(3, book.getLanguage());
        ps.setInt(4, book.getPublicationYear());
        ps.setInt(5, book.getTotalQuantity());
        ps.setInt(6, book.getAvailableQuantity());
        ps.setInt(7, book.getPublisherID());
        ps.setInt(8, book.getCategoryID());
    }

    // ─── Lấy danh sách Author cho dropdown ───────────────────────────────────
    public List<String[]> getAllAuthors() {
        List<String[]> list = new ArrayList<>();
        String sql = "SELECT AuthorID, FullName FROM Author ORDER BY FullName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new String[]{rs.getString("AuthorID"), rs.getString("FullName")});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Tìm AuthorID theo tên, nếu chưa có thì tạo mới
    public int getOrCreateAuthor(String fullName) {
        // Tìm trước
        String selectSql = "SELECT AuthorID FROM Author WHERE FullName = ?";
        try (PreparedStatement ps = connection.prepareStatement(selectSql)) {
            ps.setNString(1, fullName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("AuthorID"); // đã có → trả về ID
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Chưa có → tạo mới
        String insertSql = "INSERT INTO Author (FullName) VALUES (?)";
        try (PreparedStatement ps = connection.prepareStatement(insertSql,
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setNString(1, fullName.trim());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Thêm vào bảng Book_Author
    private void addBookAuthor(String isbn, int authorID) {
        String sql = "INSERT INTO Book_Author (ISBN, AuthorID) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ps.setInt(2, authorID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Kiểm tra tên sách đã tồn tại chưa
    public boolean isBookExist(String title) {
        String sql = "SELECT COUNT(*) FROM Book WHERE Title = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, title.trim());
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
}
