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

    public List<Book> getBooks(int offset, int limit) {
        List<Book> books = new ArrayList<>();
        String sql
                = "SELECT b.ISBN, b.Title, b.Language, b.PublicationYear, "
                + "       b.TotalQuantity, b.AvailableQuantity, "
                + "       c.CategoryName, p.PublisherName, "
                + "       STUFF((SELECT ', ' + a2.FullName "
                + "              FROM Book_Author ba2 JOIN Author a2 ON ba2.AuthorID = a2.AuthorID "
                + "              WHERE ba2.ISBN = b.ISBN "
                + "              FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1, 2, '') AS Authors "
                + "FROM Book b "
                + "LEFT JOIN Category  c ON b.CategoryID  = c.CategoryID "
                + "LEFT JOIN Publisher p ON b.PublisherID = p.PublisherID "
                + "ORDER BY b.Title "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
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

    public int getTotalBooks() {
        String sql = "SELECT COUNT(*) FROM Book";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Book getBookByISBN(String isbn) {
        String sql
                = "SELECT b.ISBN, b.Title, b.Language, b.PublicationYear, "
                + "       b.TotalQuantity, b.AvailableQuantity, "
                + "       c.CategoryName, p.PublisherName, "
                + "       STUFF((SELECT ', ' + a2.FullName "
                + "              FROM Book_Author ba2 JOIN Author a2 ON ba2.AuthorID = a2.AuthorID "
                + "              WHERE ba2.ISBN = b.ISBN "
                + "              FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1, 2, '') AS Authors "
                + "FROM Book b "
                + "LEFT JOIN Category  c ON b.CategoryID  = c.CategoryID "
                + "LEFT JOIN Publisher p ON b.PublisherID = p.PublisherID "
                + "WHERE b.ISBN = ?";
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

    public List<Book> searchBooks(String keyword, int offset, int limit) {
        List<Book> books = new ArrayList<>();
        String sql
                = "SELECT b.ISBN, b.Title, b.Language, b.PublicationYear, "
                + "       b.TotalQuantity, b.AvailableQuantity, "
                + "       c.CategoryName, p.PublisherName, "
                + "       STUFF((SELECT ', ' + a2.FullName "
                + "              FROM Book_Author ba2 JOIN Author a2 ON ba2.AuthorID = a2.AuthorID "
                + "              WHERE ba2.ISBN = b.ISBN "
                + "              FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'), 1, 2, '') AS Authors "
                + "FROM Book b "
                + "LEFT JOIN Category  c ON b.CategoryID  = c.CategoryID "
                + "LEFT JOIN Publisher p ON b.PublisherID = p.PublisherID "
                + "WHERE b.Title LIKE ? OR b.ISBN LIKE ? "
                + "   OR EXISTS (SELECT 1 FROM Book_Author ba3 JOIN Author a3 ON ba3.AuthorID = a3.AuthorID "
                + "              WHERE ba3.ISBN = b.ISBN AND a3.FullName LIKE ?) "
                + "ORDER BY b.Title "
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
                    books.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    public int getTotalSearchBooks(String keyword) {
        String sql = "SELECT COUNT(*) FROM Book b "
                   + "WHERE b.Title LIKE ? OR b.ISBN LIKE ? "
                   + "   OR EXISTS (SELECT 1 FROM Book_Author ba3 JOIN Author a3 ON ba3.AuthorID = a3.AuthorID "
                   + "              WHERE ba3.ISBN = b.ISBN AND a3.FullName LIKE ?)";
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
                ps.setNull(7, Types.INTEGER);
            }
            if (book.getCategoryID() > 0) {
                ps.setInt(8, book.getCategoryID());
            } else {
                ps.setNull(8, Types.INTEGER);
            }
            boolean ok = ps.executeUpdate() > 0;
            if (ok && book.getAuthorID() > 0) {
                addBookAuthor(book.getIsbn(), book.getAuthorID());
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBook(Book book) {
        String sql
                = "UPDATE Book SET Title=?, Language=?, PublicationYear=?, "
                + "                TotalQuantity=?, AvailableQuantity=?, PublisherID=?, CategoryID=? "
                + "WHERE ISBN=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, book.getTitle());
            ps.setNString(2, book.getLanguage());
            ps.setInt(3, book.getPublicationYear());
            ps.setInt(4, book.getTotalQuantity());
            ps.setInt(5, book.getAvailableQuantity());
            if (book.getPublisherID() > 0) {
                ps.setInt(6, book.getPublisherID());
            } else {
                ps.setNull(6, Types.INTEGER);
            }
            if (book.getCategoryID() > 0) {
                ps.setInt(7, book.getCategoryID());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setString(8, book.getIsbn());
            boolean ok = ps.executeUpdate() > 0;
            // Cập nhật tác giả nếu có nhập
            if (ok && book.getAuthorID() > 0) {
                deleteBookAuthors(book.getIsbn());
                addBookAuthor(book.getIsbn(), book.getAuthorID());
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ── Xóa Book_Author trước để tránh lỗi FK, sau đó xóa Book ──────────────
    public boolean deleteBook(String isbn) {
        deleteBookAuthors(isbn); // xóa FK trước
        String sql = "DELETE FROM Book WHERE ISBN = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateAvailable(String isbn, int delta) {
        String sql
                = "UPDATE Book SET AvailableQuantity = AvailableQuantity + ? "
                + "WHERE ISBN = ? AND (AvailableQuantity + ?) >= 0";
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

    // ── Kiểm tra tên sách đã tồn tại chưa ───────────────────────────────────
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

    // ── Kiểm tra ISBN đã tồn tại chưa ────────────────────────────────────────
    public boolean isISBNExist(String isbn) {
        String sql = "SELECT COUNT(*) FROM Book WHERE ISBN = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn.trim());
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

    public int getOrCreateAuthor(String fullName) {
        String selectSql = "SELECT AuthorID FROM Author WHERE FullName = ?";
        try (PreparedStatement ps = connection.prepareStatement(selectSql)) {
            ps.setNString(1, fullName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("AuthorID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

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

    private void deleteBookAuthors(String isbn) {
        String sql = "DELETE FROM Book_Author WHERE ISBN = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
}
