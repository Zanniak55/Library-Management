<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, model.Transaction, model.Staff"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh sách mượn sách</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f2f5; display: flex; }

        /* SIDEBAR */
        .sidebar { width: 220px; min-height: 100vh; background: #1a2238; color: white; position: fixed; top: 0; left: 0; }
        .sidebar-logo { padding: 20px 16px; font-size: 18px; font-weight: bold; border-bottom: 1px solid #2d3a55; display: flex; align-items: center; gap: 8px; }
        .sidebar-logo span { color: #4a90d9; font-size: 22px; }
        .sidebar-menu { padding: 12px 0; }
        .sidebar-menu a { display: flex; align-items: center; gap: 10px; padding: 11px 20px; color: #aab4c8; text-decoration: none; font-size: 14px; transition: background 0.2s; }
        .sidebar-menu a:hover, .sidebar-menu a.active { background: #2d3a55; color: white; }
        .sidebar-menu .section-title { padding: 14px 20px 6px; font-size: 11px; color: #556; text-transform: uppercase; letter-spacing: 1px; }

        /* MAIN */
        .main { margin-left: 220px; flex: 1; min-height: 100vh; }

        /* TOPBAR */
        .topbar { background: white; padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .topbar h2 { font-size: 20px; color: #333; }
        .topbar-right { display: flex; align-items: center; gap: 12px; font-size: 14px; color: #555; }
        .badge-role { background: #4a90d9; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; }
        .btn-logout { border: 1px solid #ccc; padding: 6px 14px; border-radius: 4px; color: #555; font-size: 13px; text-decoration: none; }
        .btn-logout:hover { background: #f5f5f5; }

        /* CONTENT */
        .content { padding: 28px; }

        /* MESSAGES */
        .msg { padding: 10px 14px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
        .ok  { background: #d4edda; color: #155724; }
        .err { background: #f8d7da; color: #721c24; }

        /* TOOLBAR */
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; }
        a.btn-create { background: #27ae60; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 14px; font-weight: bold; }
        a.btn-create:hover { background: #219150; }

        /* SEARCH BAR */
        .search-bar { display: flex; gap: 8px; align-items: center; margin-bottom: 16px; background: white; padding: 12px 16px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.08); }
        .search-bar input[type=text] { flex: 1; padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }
        .search-bar input[type=text]:focus { outline: none; border-color: #4a90d9; }
        .search-bar select { padding: 8px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 13px; }
        .search-bar button { padding: 8px 18px; background: #4a90d9; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 13px; font-weight: bold; }
        .search-bar button:hover { background: #357abd; }
        .search-bar a.clear-btn { padding: 8px 12px; color: #888; font-size: 13px; text-decoration: none; white-space: nowrap; }
        .search-bar a.clear-btn:hover { color: #333; }

        /* TABLE */
        .table-wrap { background: white; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
        table { border-collapse: collapse; width: 100%; }
        th { background: #34495e; color: white; padding: 11px 14px; text-align: left; font-size: 13px; font-weight: 600; }
        td { padding: 10px 14px; border-bottom: 1px solid #f0f0f0; font-size: 13px; color: #333; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8f9fb; }
        tr.overdue td { background: #fff5f5; }
        tr.overdue:hover td { background: #fee; }
        tr.overdue .status-cell { color: #c0392b; font-weight: bold; }

        /* BUTTONS */
        a.detail-btn { background: #95a5a6; color: white; padding: 4px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; margin-right: 4px; }
        a.detail-btn:hover { background: #7f8c8d; }
        a.return-btn { background: #e74c3c; color: white; padding: 4px 10px; border-radius: 4px; text-decoration: none; font-size: 12px; }
        a.return-btn:hover { background: #c0392b; }

        .empty { text-align: center; padding: 40px; color: #aaa; font-size: 14px; }
    </style>
</head>
<body>

<%
    Staff staff = (Staff) session.getAttribute("staff");
    String ctx = request.getContextPath();
%>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-logo"><span>📚</span> Thư viện</div>
    <div class="sidebar-menu">
        <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
        <div class="section-title">Quản lý</div>
        <a href="<%= ctx %>/loan?action=list" class="active">📋 Mượn / Trả sách</a>
        <a href="<%= ctx %>/MemberServlet">👥 Thành viên</a>
        <a href="#">📖 Sách</a>
        <a href="#">📦 Bản sao sách</a>
        <a href="#">🏷️ Thể loại</a>
        <a href="#">✍️ Tác giả</a>
        <a href="#">🏢 Nhà xuất bản</a>
        <div class="section-title">Hệ thống</div>
        <a href="<%= ctx %>/StaffServlet">👤 Quản lý nhân sự</a>
        <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
    </div>
</div>

<!-- MAIN -->
<div class="main">
    <!-- TOPBAR -->
    <div class="topbar">
        <h2>Danh sách mượn / trả sách</h2>
        <div class="topbar-right">
            👤 <%= staff != null ? staff.getFullName() : "" %>
            <% if (staff != null) { %><span class="badge-role"><%= staff.getRole() %></span><% } %>
            <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="content">

        <% String msg = request.getParameter("msg");
           if ("borrowed".equals(msg)) { %><div class="msg ok">✓ Tạo phiếu mượn thành công!</div><% }
           if ("returned".equals(msg)) { %><div class="msg ok">✓ Trả sách thành công!</div><% }
           if ("error".equals(msg))    { %><div class="msg err">✕ Có lỗi xảy ra, thử lại.</div><% } %>

        <div class="toolbar">
            <a href="<%= ctx %>/loan?action=borrow" class="btn-create">+ Tạo phiếu mượn</a>
        </div>

        <%
            String kw = (String) request.getAttribute("keyword");
            String st = (String) request.getAttribute("status");
            if (kw == null) kw = "";
            if (st == null) st = "";
        %>
        <form method="get" action="<%= ctx %>/loan" class="search-bar">
            <input type="hidden" name="action" value="list">
            <input type="text" name="keyword" placeholder="Tìm theo tên thành viên..." value="<%= kw %>">
            <select name="status">
                <option value="" <%= st.isEmpty() ? "selected" : "" %>>-- Tất cả trạng thái --</option>
                <option value="Đang mượn" <%= "Đang mượn".equals(st) ? "selected" : "" %>>Đang mượn</option>
                <option value="Đã trả"    <%= "Đã trả".equals(st)    ? "selected" : "" %>>Đã trả</option>
                <option value="Quá hạn"   <%= "Quá hạn".equals(st)   ? "selected" : "" %>>Quá hạn</option>
            </select>
            <button type="submit">🔍 Tìm kiếm</button>
            <% if (!kw.isEmpty() || !st.isEmpty()) { %>
            <a href="<%= ctx %>/loan?action=list" class="clear-btn">✕ Xóa bộ lọc</a>
            <% } %>
        </form>

        <div class="table-wrap">
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
                    if (list == null || list.isEmpty()) {
                %>
                <tr><td colspan="7" class="empty">Không có phiếu mượn nào.</td></tr>
                <%
                    } else {
                        for (Transaction t : list) {
                            boolean overdue = "Quá hạn".equals(t.getStatus());
                %>
                <tr class="<%= overdue ? "overdue" : "" %>">
                    <td>#<%= t.getTransactionID() %></td>
                    <td><%= t.getMemberName() %></td>
                    <td><%= t.getBorrowDate() %></td>
                    <td><%= t.getDueDate() %></td>
                    <td><%= t.getReturnDate() != null ? t.getReturnDate() : "—" %></td>
                    <td class="<%= overdue ? "status-cell" : "" %>">
                        <%= t.getStatus() %><%= overdue ? " ⚠️" : "" %>
                    </td>
                    <td>
                        <a href="<%= ctx %>/loan?action=detail&id=<%= t.getTransactionID() %>" class="detail-btn">Chi tiết</a>
                        <% if ("Đang mượn".equals(t.getStatus()) || overdue) { %>
                        <a href="<%= ctx %>/loan?action=return&id=<%= t.getTransactionID() %>"
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
        </div>

    </div>
</div>

</body>
</html>
