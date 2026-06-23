<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách mượn sách</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
            h2 { margin-bottom: 12px; }
            table { border-collapse: collapse; width: 100%; background: white; }
            th { background: #34495e; color: white; padding: 10px; text-align: left; }
            td { padding: 9px 10px; border-bottom: 1px solid #ddd; }
            tr:hover td { background: #f0f0f0; }
            a.btn { background: #27ae60; color: white; padding: 7px 14px; border-radius: 4px; text-decoration: none; font-size: 13px; }
            a.return-btn { background: #e74c3c; color: white; padding: 4px 10px; border-radius: 4px; text-decoration: none; font-size: 13px; }
            .msg { padding: 8px 12px; border-radius: 4px; margin-bottom: 12px; }
            .ok  { background: #d4edda; color: #155724; }
            .err { background: #f8d7da; color: #721c24; }
            .topbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
            .search-bar { display: flex; gap: 8px; align-items: center; margin-bottom: 14px; background: white; padding: 12px 16px; border-radius: 6px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
            .search-bar input[type=text] { flex: 1; padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
            .search-bar select { padding: 7px 10px; border: 1px solid #ccc; border-radius: 4px; font-size: 13px; }
            .search-bar button { padding: 7px 16px; background: #2980b9; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
            .search-bar button:hover { background: #1f6fa3; }
            .search-bar a.clear-btn { padding: 7px 12px; color: #666; font-size: 13px; text-decoration: none; }
            .search-bar a.clear-btn:hover { color: #333; }
        </style>
    </head>
    <body>

        <div class="topbar">
            <h2>Danh sách mượn / trả sách</h2>
            <span>
                <a href="${pageContext.request.contextPath}/dashboard">Dashboard</a> |
                <a href="${pageContext.request.contextPath}/loan?action=logout">Đăng xuất</a>
            </span>
        </div>

        <% String msg = request.getParameter("msg");
           if ("borrowed".equals(msg)) { %><div class="msg ok">Tạo phiếu mượn thành công!</div><% }
           if ("returned".equals(msg)) { %><div class="msg ok">Trả sách thành công!</div><% }
           if ("error".equals(msg))    { %><div class="msg err">Có lỗi xảy ra!</div><% } %>

        <a href="${pageContext.request.contextPath}/loan?action=borrow" class="btn">+ Tạo phiếu mượn</a>
        <br><br>

        <%
            String kw  = (String) request.getAttribute("keyword");
            String st  = (String) request.getAttribute("status");
            if (kw == null) kw = "";
            if (st == null) st = "";
        %>
        <form method="get" action="${pageContext.request.contextPath}/loan" class="search-bar">
            <input type="hidden" name="action" value="list">
            <input type="text" name="keyword" placeholder="Tìm theo tên thành viên..." value="<%= kw %>">
            <select name="status">
                <option value="" <%= st.isEmpty() ? "selected" : "" %>>-- Tất cả trạng thái --</option>
                <option value="Đang mượn"  <%= "Đang mượn".equals(st)  ? "selected" : "" %>>Đang mượn</option>
                <option value="Đã trả"     <%= "Đã trả".equals(st)     ? "selected" : "" %>>Đã trả</option>
                <option value="Quá hạn"    <%= "Quá hạn".equals(st)    ? "selected" : "" %>>Quá hạn</option>
            </select>
            <button type="submit">Tìm kiếm</button>
            <% if (!kw.isEmpty() || !st.isEmpty()) { %>
            <a href="${pageContext.request.contextPath}/loan?action=list" class="clear-btn">✕ Xóa bộ lọc</a>
            <% } %>
        </form>

        <table>
            <tr>
                <th>Mã phiếu</th>
                <th>Thành viên</th>
                <th>Ngày mượn</th>
                <th>Hạn trả</th>
                <th>Ngày trả</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            <%
                List<Transaction> list = (List<Transaction>) request.getAttribute("transactions");
                if (list != null) {
                    for (Transaction t : list) {
            %>
            <tr>
                <td><%= t.getTransactionID() %></td>
                <td><%= t.getMemberName() %></td>
                <td><%= t.getBorrowDate() %></td>
                <td><%= t.getDueDate() %></td>
                <td><%= t.getReturnDate() != null ? t.getReturnDate() : "—" %></td>
                <td><%= t.getStatus() %></td>
                <td>
                    <% if ("Đang mượn".equals(t.getStatus())) { %>
                    <a href="${pageContext.request.contextPath}/loan?action=return&id=<%= t.getTransactionID() %>"
                       class="return-btn"
                       onclick="return confirm('Xác nhận trả sách?')">Trả sách</a>
                    <% } %>
                </td>
            </tr>
            <%
                    }
                }
            %>
        </table>

    </body>
</html>
