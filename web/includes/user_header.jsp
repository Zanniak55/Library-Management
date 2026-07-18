<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
    model.Member user = (model.Member) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(ctx + "/user-login");
        return;
    }
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Cổng Độc Giả";
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) activePage = "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= ctx %>/css/user_layout.css">
    <style>
        :root {
            --sidebar-bg: #78350f;
            --sidebar-hover: #92400e;
            --primary: #f59e0b;
            --primary-dark: #d97706;
            --primary-light: #fef3c7;
        }
    </style>
</head>
<body>
    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <span>📚</span>
            Thư viện
        </div>
        <div class="sidebar-menu">
            <a href="<%= ctx %>/user/dashboard" class="<%= "dashboard".equals(activePage) ? "active" : "" %>">
                <span>📊</span> Tổng quan
            </a>
            <a href="<%= ctx %>/user/books" class="<%= "books".equals(activePage) ? "active" : "" %>">
                <span>🔍</span> Tra cứu sách
            </a>
            <a href="<%= ctx %>/user/reservations" class="<%= "reservations".equals(activePage) ? "active" : "" %>">
                <span>🛒</span> Yêu cầu mượn
            </a>
            <a href="<%= ctx %>/user/loans" class="<%= "loans".equals(activePage) ? "active" : "" %>">
                <span>📋</span> Biên bản mượn
            </a>
            <a href="<%= ctx %>/user/fines" class="<%= "fines".equals(activePage) ? "active" : "" %>">
                <span>💰</span> Biên bản phạt
            </a>
            <a href="<%= ctx %>/user/profile" class="<%= "profile".equals(activePage) ? "active" : "" %>">
                <span>👤</span> Tài khoản
            </a>
            <div style="margin: 20px 24px; border-top: 1px solid rgba(255,255,255,0.1);"></div>
            <a href="<%= ctx %>/user-logout">
                <span>🚪</span> Đăng xuất
            </a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">
        <!-- TOPBAR -->
        <div class="topbar">
            <div class="page-title"><%= pageTitle %></div>
            <div class="user-info" style="display:flex; align-items:center; gap:12px;">
                <span class="user-role badge" style="background:#fef3c7;color:#b45309;padding:4px 8px;border-radius:12px;font-size:12px;font-weight:600;"><%= user.getMemberType() != null ? user.getMemberType() : "Độc giả" %></span>
                <span class="user-name" style="font-weight:600;"><%= user.getFullName() %></span>
                <div class="user-avatar" style="width:36px;height:36px;border-radius:50%;background:var(--primary);color:white;display:flex;align-items:center;justify-content:center;font-weight:bold;">
                    <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <a href="<%= ctx %>/user-logout" style="padding:6px 12px; background:#fef2f2; color:#ef4444; border-radius:6px; text-decoration:none; font-size:13px; font-weight:600; margin-left:12px; transition:0.2s;">Đăng xuất</a>
            </div>
        </div>

        <!-- CONTENT AREA -->
        <div class="content">
