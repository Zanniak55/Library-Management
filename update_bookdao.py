import re

with open('src/java/dao/BookDAO.java', 'r', encoding='utf-8') as f:
    content = f.read()

# Add getBooks paginated
content = re.sub(
    r'public List<Book> getAllBooks\(\) \{.*?return books;\s*\}',
    '''public List<Book> getBooks(int offset, int limit) {
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
    }''', content, flags=re.DOTALL)

# Add searchBooks paginated
content = re.sub(
    r'public List<Book> searchBooks\(String keyword\) \{.*?return books;\s*\}',
    '''public List<Book> searchBooks(String keyword, int offset, int limit) {
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
    }''', content, flags=re.DOTALL)

with open('src/java/dao/BookDAO.java', 'w', encoding='utf-8') as f:
    f.write(content)
