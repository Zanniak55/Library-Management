<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Staff"%>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Dashboard - Quản lý Thư viện</title>
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
        .main { margin-left: 220px; flex: 1; padding: 0; }

        /* TOPBAR */
        .topbar { background: white; padding: 14px 28px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.08); }
        .topbar h2 { font-size: 20px; color: #333; }
        .topbar-right { display: flex; align-items: center; gap: 12px; font-size: 14px; color: #555; }
        .badge-role { background: #4a90d9; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; }
        .btn-logout { background: none; border: 1px solid #ccc; padding: 6px 14px; border-radius: 4px; cursor: pointer; color: #555; font-size: 13px; text-decoration: none; }
        .btn-logout:hover { background: #f5f5f5; }

        /* CONTENT */
        .content { padding: 28px; }

        /* STAT CARDS */
        .cards { display: flex; gap: 20px; flex-wrap: wrap; margin-bottom: 28px; }
        .card { flex: 1; min-width: 180px; border-radius: 10px; padding: 22px 24px; color: white; display: flex; justify-content: space-between; align-items: center; }
        .card-green  { background: #27ae60; }
        .card-purple { background: #8e44ad; }
        .card-blue   { background: #2980b9; }
        .card-orange { background: #e67e22; }
        .card-red    { background: #e74c3c; }
        .card-num { font-size: 36px; font-weight: bold; }
        .card-label { font-size: 13px; margin-top: 4px; opacity: 0.9; }
        .card-icon { font-size: 40px; opacity: 0.4; }

        /* QUICK LINKS */
        .quick-title { font-size: 16px; font-weight: bold; color: #333; margin-bottom: 14px; }
        .quick-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
        .quick-card { background: white; border-radius: 8px; padding: 18px; text-decoration: none; color: #333; border-left: 4px solid #4a90d9; box-shadow: 0 1px 4px rgba(0,0,0,0.06); transition: box-shadow 0.2s; }
        .quick-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.12); }
        .quick-card h4 { font-size: 15px; margin-bottom: 4px; }
        .quick-card p { font-size: 12px; color: #888; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-logo"><span>📚</span> Thư viện</div>
    <div class="sidebar-menu">
        <a href="<%= ctx %>/dashboard" class="active">🏠 Dashboard</a>

        <div class="section-title">Quản lý</div>
        <a href="<%= ctx %>/loan?action=list">📋 Mượn / Trả sách</a>
        <a href="<%= ctx %>/fine?action=list">💰 Quản lý phạt</a>
        <a href="<%= ctx %>/fine?action=stats">📊 Thống kê phạt</a>
        <a href="#">👥 Thành viên</a>
        <a href="#">📖 Sách</a>
        <a href="#">📦 Bản sao sách</a>
        <a href="#">🏷️ Thể loại</a>
        <a href="#">✍️ Tác giả</a>
        <a href="#">🏢 Nhà xuất bản</a>

        <div class="section-title">Hệ thống</div>
        <a href="#">👤 Quản lý nhân sự</a>
        <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
    </div>
</div>

<!-- MAIN -->
<div class="main">
    <!-- TOPBAR -->
    <div class="topbar">
        <h2>Dashboard</h2>
        <div class="topbar-right">
            👤 <%= staff.getFullName() %>
            <span class="badge-role"><%= staff.getRole() %></span>
            <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="content">
        <!-- STAT CARDS -->
        <div class="cards">
            <div class="card card-green">
                <div>
                    <div class="card-num">${totalMembers}</div>
                    <div class="card-label">Tổng thành viên</div>
                </div>
                <div class="card-icon">👥</div>
            </div>
            <div class="card card-purple">
                <div>
                    <div class="card-num">${activeMembers}</div>
                    <div class="card-label">Thành viên hoạt động</div>
                </div>
                <div class="card-icon">✅</div>
            </div>
            <div class="card card-blue">
                <div>
                    <div class="card-num">${totalStaff}</div>
                    <div class="card-label">Tổng nhân viên</div>
                </div>
                <div class="card-icon">👤</div>
            </div>
            <div class="card card-orange">
                <div>
                    <div class="card-num">${totalBooks}</div>
                    <div class="card-label">Tổng số sách</div>
                </div>
                <div class="card-icon">📚</div>
            </div>
            <div class="card card-red">
                <div>
                    <div class="card-num">${borrowingNow}</div>
                    <div class="card-label">Đang cho mượn</div>
                </div>
                <div class="card-icon">📤</div>
            </div>
        </div>

        <!-- QUICK LINKS -->
        <div class="quick-title">Truy cập nhanh</div>
        <div class="quick-grid">
            <a href="<%= ctx %>/loan?action=list" class="quick-card">
                <h4>📋 Danh sách phiếu mượn</h4>
                <p>Xem và quản lý phiếu mượn sách</p>
            </a>
            <a href="<%= ctx %>/loan?action=borrow" class="quick-card">
                <h4>➕ Tạo phiếu mượn</h4>
                <p>Tạo phiếu mượn sách mới</p>
            </a>
            <a href="#" class="quick-card">
                <h4>👥 Thành viên</h4>
                <p>Quản lý danh sách thành viên</p>
            </a>
            <a href="#" class="quick-card">
                <h4>📖 Sách</h4>
                <p>Thêm, sửa, xóa sách</p>
            </a>
            <a href="#" class="quick-card">
                <h4>📦 Bản sao sách</h4>
                <p>Quản lý bản sao vật lý</p>
            </a>
            <a href="#" class="quick-card">
                <h4>👤 Nhân sự</h4>
                <p>Quản lý tài khoản nhân viên</p>
            </a>
        </div>
    </div>
</div>

</body>
</html>
