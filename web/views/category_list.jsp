<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff, model.Category, java.util.List"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String keyword = request.getParameter("keyword");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thể Loại - Quản lý Thư viện</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }
            body {
                font-family: Arial, sans-serif;
                background: #f0f2f5;
                display: flex;
            }
            .sidebar {
                width: 220px;
                min-height: 100vh;
                background: #1a2238;
                color: white;
                position: fixed;
                top: 0;
                left: 0;
                overflow-y: auto;
            }
            .sidebar-logo {
                padding: 20px 16px;
                font-size: 18px;
                font-weight: bold;
                border-bottom: 1px solid #2d3a55;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .sidebar-logo span {
                color: #4a90d9;
                font-size: 22px;
            }
            .sidebar-menu {
                padding: 12px 0;
            }
            .sidebar-menu a {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 11px 20px;
                color: #aab4c8;
                text-decoration: none;
                font-size: 14px;
                transition: background 0.2s;
            }
            .sidebar-menu a:hover, .sidebar-menu a.active {
                background: #2d3a55;
                color: white;
            }
            .sidebar-menu .section-title {
                padding: 14px 20px 6px;
                font-size: 11px;
                color: #556;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .main {
                margin-left: 220px;
                flex: 1;
            }
            .topbar {
                background: white;
                padding: 14px 28px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            }
            .topbar h2 {
                font-size: 20px;
                color: #333;
            }
            .topbar-right {
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                color: #555;
            }
            .badge-role {
                background: #4a90d9;
                color: white;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
            }
            .btn-logout {
                background: none;
                border: 1px solid #ccc;
                padding: 6px 14px;
                border-radius: 4px;
                cursor: pointer;
                color: #555;
                font-size: 13px;
                text-decoration: none;
            }
            .btn-logout:hover {
                background: #f5f5f5;
            }
            .content {
                padding: 28px;
            }
            /* Table styles */
            .toolbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 18px;
                gap: 12px;
            }
            .search-box {
                display: flex;
                gap: 8px;
                flex: 1;
                max-width: 400px;
            }
            .search-box input {
                flex: 1;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
            }
            .search-box button {
                padding: 8px 16px;
                background: #4a90d9;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
            }
            .search-box button:hover {
                background: #357abd;
            }
            .btn-add {
                padding: 9px 20px;
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }
            .btn-add:hover {
                background: #219a52;
            }
            .btn-clear {
                padding: 8px 14px;
                background: #eee;
                color: #555;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 13px;
                text-decoration: none;
            }
            .table-wrap {
                background: white;
                border-radius: 10px;
                box-shadow: 0 1px 6px rgba(0,0,0,0.08);
                overflow: hidden;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead tr {
                background: #1a2238;
                color: white;
            }
            th {
                padding: 13px 16px;
                text-align: left;
                font-size: 13px;
                font-weight: 600;
            }
            td {
                padding: 12px 16px;
                font-size: 14px;
                border-bottom: 1px solid #f0f0f0;
                color: #333;
            }
            tbody tr:last-child td {
                border-bottom: none;
            }
            tbody tr:hover {
                background: #f8f9ff;
            }
            .badge-cat {
                display: inline-block;
                background: #e8f5e9;
                color: #2e7d32;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 13px;
                font-weight: 500;
            }
            .desc-cell {
                color: #777;
                font-size: 13px;
            }
            .action-btns {
                display: flex;
                gap: 8px;
            }
            .btn-edit {
                padding: 5px 12px;
                background: #fff3e0;
                color: #e65100;
                border: 1px solid #ffcc80;
                border-radius: 5px;
                text-decoration: none;
                font-size: 13px;
            }
            .btn-edit:hover {
                background: #ffe0b2;
            }
            .btn-del {
                padding: 5px 12px;
                background: #fdecea;
                color: #c62828;
                border: 1px solid #ef9a9a;
                border-radius: 5px;
                text-decoration: none;
                font-size: 13px;
                cursor: pointer;
            }
            .btn-del:hover {
                background: #ffcdd2;
            }
            .empty-row td {
                text-align: center;
                padding: 40px;
                color: #aaa;
                font-size: 14px;
            }
            .count-text {
                margin-top: 10px;
                font-size: 13px;
                color: #888;
            }
            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 16px;
                font-size: 14px;
            }
            .alert-success {
                background: #e8f5e9;
                color: #2e7d32;
                border-left: 4px solid #4caf50;
            }
            .alert-error   {
                background: #fdecea;
                color: #c62828;
                border-left: 4px solid #ef5350;
            }
        </style>
    </head>
    <body>
        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="sidebar-logo"><span>📚</span> Thư viện</div>
            <div class="sidebar-menu">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
                <div class="section-title">Quản lý</div>
                <a href="<%= ctx %>/loan?action=list">📋 Mượn / Trả sách</a>
                <a href="<%= ctx %>/fine?action=list">💰 Quản lý phạt</a>
                <a href="<%= ctx %>/fine?action=stats">📊 Thống kê phạt</a>
                <a href="<%= ctx %>/members">👥 Thành viên</a>
                <a href="<%= ctx %>/books">📖 Sách</a>
                <a href="<%= ctx %>/bookcopies">📦 Bản sao sách</a>
                <a href="<%= ctx %>/categories" class="active">🏷️ Thể loại</a>
                <a href="<%= ctx %>/authors">✍️ Tác giả</a>
                <a href="<%= ctx %>/publishers">🏢 Nhà xuất bản</a>
                <div class="section-title">Hệ thống</div>
                <a href="<%= ctx %>/staffs">👤 Quản lý nhân sự</a>
                <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
        <div class="main">
            <div class="topbar">
                <h2>🏷️ Quản lý Thể Loại</h2>
                <div class="topbar-right">
                    👤 <%= staff.getFullName() %>
                    <span class="badge-role"><%= staff.getRole() %></span>
                    <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <div class="content">
                <%-- Thông báo --%>
                <% String success = (String) session.getAttribute("success");
                   String error   = (String) session.getAttribute("error");
                   if (success != null) { session.removeAttribute("success"); %>
                <div class="alert alert-success">✅ <%= success %></div>
                <% } if (error != null) { session.removeAttribute("error"); %>
                <div class="alert alert-error">❌ <%= error %></div>
                <% } %>

                <div class="toolbar">
                    <form action="<%= ctx %>/categories" method="get" style="display:flex;gap:8px;flex:1;max-width:400px;">
                        <input type="hidden" name="action" value="search">
                        <input class="search-box" type="text" name="keyword" placeholder="Tìm thể loại…"
                               value="<%= keyword != null ? keyword : "" %>"
                               style="flex:1;padding:8px 12px;border:1px solid #ddd;border-radius:6px;font-size:14px;">
                        <button type="submit" style="padding:8px 16px;background:#4a90d9;color:white;border:none;border-radius:6px;cursor:pointer;">🔍</button>
                        <% if (keyword != null && !keyword.isEmpty()) { %>
                        <a href="<%= ctx %>/categories" class="btn-clear">Xóa</a>
                        <% } %>
                    </form>
                    <a href="<%= ctx %>/categories?action=new" class="btn-add">➕ Thêm Thể Loại</a>
                </div>

                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr><th>#</th><th>Tên Thể Loại</th><th>Mô Tả</th><th>Thao Tác</th></tr>
                        </thead>
                        <tbody>
                            <% if (categories == null || categories.isEmpty()) { %>
                            <tr class="empty-row"><td colspan="4">📭 Không có thể loại nào.</td></tr>
                            <% } else {
                                int i = 1;
                                for (Category cat : categories) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge-cat"><%= cat.getCategoryName() %></span></td>
                                <td class="desc-cell"><%= cat.getDescription() != null && !cat.getDescription().isEmpty() ? cat.getDescription() : "—" %></td>
                                <td>
                                    <div class="action-btns">
                                        <a href="<%= ctx %>/categories?action=edit&id=<%= cat.getCategoryID() %>" class="btn-edit">✏️ Sửa</a>
                                        <a href="<%= ctx %>/categories?action=delete&id=<%= cat.getCategoryID() %>"
                                           class="btn-del"
                                           onclick="return confirm('Xóa thể loại «<%= cat.getCategoryName() %>»?')">🗑️ Xóa</a>
                                    </div>
                                </td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
                <p class="count-text">Tổng cộng: <strong><%= categories != null ? categories.size() : 0 %></strong> thể loại</p>
            </div>
        </div>
    </body>
</html>
