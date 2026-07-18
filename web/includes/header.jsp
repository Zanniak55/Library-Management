<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff"%>
<%
    Staff _staff = (Staff) session.getAttribute("staff");
    if (_staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String _ctx = request.getContextPath();
    boolean _isAdmin = "Admin".equals(_staff.getRole());
    String _pageTitle = (String) request.getAttribute("pageTitle");
    if (_pageTitle == null) {
        _pageTitle = "Quản lý Thư viện";
    }
    String _activePage = (String) request.getAttribute("activePage");
    if (_activePage == null) {
        _activePage = "";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= _pageTitle %></title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="<%= _ctx %>/css/layout.css?v=<%= System.currentTimeMillis() %>">
        <style>
            :root {
                <% if (_isAdmin) { %>
                --sidebar-bg: #0f172a;
                --sidebar-hover: #1e293b;
                --primary: #4f46e5;
                --primary-hover: #4338ca;
                --card-1: linear-gradient(135deg, #4f46e5, #3b82f6);
                --card-2: linear-gradient(135deg, #9333ea, #db2777);
                --card-3: linear-gradient(135deg, #0284c7, #0369a1);
                --card-4: linear-gradient(135deg, #ea580c, #c2410c);
                --card-5: linear-gradient(135deg, #e11d48, #be123c);
                <% } else { %>
                --sidebar-bg: #064e3b;
                --sidebar-hover: #047857;
                --primary: #059669;
                --primary-hover: #047857;
                --card-1: linear-gradient(135deg, #059669, #10b981);
                --card-2: linear-gradient(135deg, #0ea5e9, #0284c7);
                --card-3: linear-gradient(135deg, #d946ef, #9333ea);
                --card-4: linear-gradient(135deg, #f59e0b, #ea580c);
                --card-5: linear-gradient(135deg, #f43f5e, #e11d48);
                <% } %>
            }
            <% if (!_isAdmin) { %>
            .cards { order: 2; }
            .quick-section { order: 1; }
            .stats-row { order: 3; }
            <% } else { %>
            .cards { order: 1; }
            .quick-section { order: 2; }
            .stats-row { order: 3; }
            <% } %>
        </style>
    </head>
    <body>

        <!-- SIDEBAR -->
        <div class="sidebar">
            <div class="sidebar-logo"><span>📚</span> Thư viện</div>
            <div class="sidebar-menu">
                <a href="<%= _ctx %>/dashboard" class="<%= "dashboard".equals(_activePage) ? "active" : "" %>">🏠 Dashboard</a>

                <% if (_isAdmin) { %>
                <a href="<%= _ctx %>/staffs" class="<%= "staffs".equals(_activePage) ? "active" : "" %>">👤 Quản lý nhân sự</a>
                <a href="<%= _ctx %>/loan-reports" class="<%= "loanstats".equals(_activePage) ? "active" : "" %>">📊 Báo cáo Mượn/Trả</a>
                <a href="<%= _ctx %>/fines?action=stats" class="<%= "finestats".equals(_activePage) ? "active" : "" %>">💰 Báo cáo Phạt</a>
                <% } %>
                <a href="<%= _ctx %>/members" class="<%= "members".equals(_activePage) ? "active" : "" %>">👥 Thành viên</a>
                <a href="<%= _ctx %>/books" class="<%= "books".equals(_activePage) ? "active" : "" %>">📖 Sách</a>
                <a href="<%= _ctx %>/bookcopies" class="<%= "bookcopies".equals(_activePage) ? "active" : "" %>">📦 Bản sao sách</a>
                <a href="<%= _ctx %>/publishers" class="<%= "publishers".equals(_activePage) ? "active" : "" %>">🏢 Nhà xuất bản</a>
                <% if (!_isAdmin) { %>
                <a href="<%= _ctx %>/reservations" class="<%= "reservations".equals(_activePage) ? "active" : "" %>">🛒 Duyệt ĐK Mượn</a>
                <a href="<%= _ctx %>/loan?action=list" class="<%= "loans".equals(_activePage) ? "active" : "" %>">📋 Mượn/Trả</a>
                <a href="<%= _ctx %>/fines?action=list" class="<%= "fines".equals(_activePage) ? "active" : "" %>">💰 Phạt</a>
                <% } %>
                <a href="<%= _ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
        <div class="main">
            <div class="topbar">
                <h2><%= _pageTitle %></h2>
                <div class="topbar-right">
                    👤 <%= _staff.getFullName() %>
                    <span class="badge-role"><%= _staff.getRole() %></span>
                    <a href="<%= _ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <div class="content">
