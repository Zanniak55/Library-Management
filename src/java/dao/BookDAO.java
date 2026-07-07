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
public class BookDAO extends DBContext{
    // ─── Lấy tất cả sách ─────────────────────────────────────────────────────
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY id DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) books.add(mapRow(rs));

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    // ─── Lấy sách theo ID ────────────────────────────────────────────────────
    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ─── Tìm kiếm theo từ khóa ───────────────────────────────────────────────
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ? OR isbn LIKE ?";
        String kw  = "%" + keyword + "%";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) books.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }

    // ─── Thêm sách ───────────────────────────────────────────────────────────
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, author, category, quantity, available, isbn, publish_year) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setParams(ps, book);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Cập nhật sách ───────────────────────────────────────────────────────
    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET title=?, author=?, category=?, quantity=?, "
                   + "available=?, isbn=?, publish_year=? WHERE id=?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            setParams(ps, book);
            ps.setInt(8, book.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Xóa sách ────────────────────────────────────────────────────────────
    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Cập nhật số lượng khi mượn / trả ───────────────────────────────────
    // delta = -1 khi mượn, +1 khi trả
    public boolean updateAvailable(int bookId, int delta) {
        String sql = "UPDATE books SET available = available + ? "
                   + "WHERE id = ? AND (available + ?) >= 0";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, delta);
            ps.setInt(2, bookId);
            ps.setInt(3, delta);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ─── Helper: ResultSet → Book ─────────────────────────────────────────────
    private Book mapRow(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setQuantity(rs.getInt("quantity"));
        b.setAvailable(rs.getInt("available"));
        b.setIsbn(rs.getString("isbn"));
        b.setPublishYear(rs.getInt("publish_year"));
        return b;
    }

    // ─── Helper: gán params cho PreparedStatement (add / update) ─────────────
    private void setParams(PreparedStatement ps, Book book) throws SQLException {
        ps.setString(1, book.getTitle());
        ps.setString(2, book.getAuthor());
        ps.setString(3, book.getCategory());
        ps.setInt(4, book.getQuantity());
        ps.setInt(5, book.getAvailable());
        ps.setString(6, book.getIsbn());
        ps.setInt(7, book.getPublishYear());
    }
}
