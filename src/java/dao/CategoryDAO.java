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
import model.Category;

/**
 *
 * @author AAA
 */
public class CategoryDAO extends DBContext {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category ORDER BY CategoryName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Category getCategoryByID(int id) {
        String sql = "SELECT * FROM Category WHERE CategoryID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
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

    public List<Category> searchCategories(String keyword) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM Category WHERE CategoryName LIKE ? OR Description LIKE ? ORDER BY CategoryName";
        String kw = "%" + keyword + "%";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, kw);
            ps.setString(2, kw);
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

    public boolean addCategory(Category cat) {
        String sql = "INSERT INTO Category (CategoryName, Description) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, cat.getCategoryName());
            ps.setNString(2, cat.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCategory(Category cat) {
        String sql = "UPDATE Category SET CategoryName=?, Description=? WHERE CategoryID=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, cat.getCategoryName());
            ps.setNString(2, cat.getDescription());
            ps.setInt(3, cat.getCategoryID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM Category WHERE CategoryID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isCategoryExist(String name) {
        String sql = "SELECT COUNT(*) FROM Category WHERE CategoryName = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setNString(1, name.trim());
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

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryID(rs.getInt("CategoryID"));
        c.setCategoryName(rs.getString("CategoryName"));
        c.setDescription(rs.getString("Description"));
        return c;
    }
}
