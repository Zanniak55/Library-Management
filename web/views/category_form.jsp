<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff, model.Category"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    Category category = (Category) request.getAttribute("category");
    String formTitle  = (String)   request.getAttribute("formTitle");
    boolean isEdit    = (category != null);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= formTitle %> - Quản lý Thư viện</title>
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
            .content {
                padding: 28px;
            }
            /* Form styles */
            .form-card {
                background: white;
                border-radius: 10px;
                box-shadow: 0 1px 6px rgba(0,0,0,0.08);
                max-width: 560px;
                overflow: hidden;
            }
            .form-card-header {
                background: #1a2238;
                color: white;
                padding: 16px 24px;
                font-size: 16px;
                font-weight: bold;
            }
            .form-card-body {
                padding: 28px 24px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                font-size: 13px;
                font-weight: 600;
                color: #555;
                margin-bottom: 6px;
            }
            .form-group input, .form-group textarea {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                font-family: Arial, sans-serif;
            }
            .form-group input:focus, .form-group textarea:focus {
                outline: none;
                border-color: #4a90d9;
                box-shadow: 0 0 0 3px rgba(74,144,217,0.15);
            }
            .form-group textarea {
                resize: vertical;
                min-height: 90px;
            }
            .required {
                color: #e53935;
            }
            .form-actions {
                display: flex;
                gap: 10px;
                margin-top: 24px;
            }
            .btn-save {
                padding: 10px 24px;
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
            }
            .btn-save:hover {
                background: #219a52;
            }
            .btn-back {
                padding: 10px 20px;
                background: #eee;
                color: #555;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                text-decoration: none;
            }
            .btn-back:hover {
                background: #e0e0e0;
            }
            .alert {
                padding: 12px 16px;
                border-radius: 8px;
                margin-bottom: 16px;
                font-size: 14px;
            }
            .alert-error {
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
                <h2><%= formTitle %></h2>
                <div class="topbar-right">
                    👤 <%= staff.getFullName() %>
                    <span class="badge-role"><%= staff.getRole() %></span>
                    <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <div class="content">
                <% String error = (String) session.getAttribute("error");
               if (error != null) { session.removeAttribute("error"); %>
                <div class="alert alert-error">❌ <%= error %></div>
                <% } %>

                <div class="form-card">
                    <div class="form-card-header">
                        <%= isEdit ? "✏️" : "➕" %> <%= formTitle %>
                    </div>
                    <div class="form-card-body">
                        <form action="<%= ctx %>/categories" method="post">
                            <input type="hidden" name="actionType" value="<%= isEdit ? "edit" : "add" %>">
                            <% if (isEdit) { %>
                            <input type="hidden" name="categoryID" value="<%= category.getCategoryID() %>">
                            <% } %>

                            <div class="form-group">
                                <label>Tên Thể Loại <span class="required">*</span></label>
                                <input type="text" name="categoryName" required maxlength="150"
                                       placeholder="Nhập tên thể loại…"
                                       value="<%= isEdit ? category.getCategoryName() : "" %>">
                            </div>

                            <div class="form-group">
                                <label>Mô Tả</label>
                                <textarea name="description" placeholder="Mô tả thể loại…"><%= isEdit && category.getDescription() != null ? category.getDescription() : "" %></textarea>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn-save">💾 <%= isEdit ? "Lưu Thay Đổi" : "Thêm Thể Loại" %></button>
                                <a href="<%= ctx %>/categories" class="btn-back">← Quay Lại</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>