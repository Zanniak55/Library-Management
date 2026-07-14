<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Staff" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Staff staff = (Staff) session.getAttribute("staff");
    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String ctx = request.getContextPath();
    boolean isAdmin = "Admin".equals(staff != null ? staff.getRole() : "");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Quản lý Thành viên - Thư viện</title>
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
        .sidebar-menu .section-title { padding: 14px 20px 6px; font-size: 11px; color: #556677; text-transform: uppercase; letter-spacing: 1px; }

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

        /* TOOLBAR */
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 10px; }
        .toolbar-left { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        .search-group { display: flex; }
        .search-input { padding: 8px 14px; border: 1px solid #ddd; border-radius: 6px 0 0 6px; font-size: 14px; outline: none; width: 260px; }
        .search-input:focus { border-color: #4a90d9; }
        .search-btn { padding: 8px 16px; background: #4a90d9; color: white; border: none; border-radius: 0 6px 6px 0; cursor: pointer; font-size: 14px; }
        .search-btn:hover { background: #357abd; }
        .btn-add { padding: 8px 18px; background: #27ae60; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn-add:hover { background: #219150; }

        /* ALERT */
        .alert { padding: 10px 16px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
        .alert-success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .alert-danger  { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }

        /* TABLE CARD */
        .table-card { background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
        .table-card-header { padding: 16px 20px; border-bottom: 1px solid #eee; display: flex; align-items: center; gap: 8px; }
        .table-card-header h3 { font-size: 16px; color: #333; font-weight: 600; }
        .table-card-header .count-badge { background: #4a90d9; color: white; font-size: 12px; padding: 2px 8px; border-radius: 12px; }

        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        thead { background: #f8f9fa; }
        thead th { padding: 12px 16px; text-align: left; color: #555; font-weight: 600; font-size: 13px; border-bottom: 2px solid #eee; white-space: nowrap; }
        tbody tr { border-bottom: 1px solid #f5f5f5; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f8faff; }
        tbody td { padding: 12px 16px; color: #333; vertical-align: middle; }

        /* BADGES */
        .badge { display: inline-block; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .badge-active  { background: #d4edda; color: #155724; }
        .badge-locked  { background: #f8d7da; color: #721c24; }
        .badge-type    { background: #dbeafe; color: #1e40af; }

        /* ACTION BUTTONS */
        .btn-edit   { padding: 5px 12px; background: #fff3cd; color: #856404; border: 1px solid #ffc107; border-radius: 4px; font-size: 12px; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; cursor: pointer; }
        .btn-edit:hover { background: #ffc107; color: #333; }
        .btn-delete { padding: 5px 12px; background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; border-radius: 4px; font-size: 12px; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; cursor: pointer; }
        .btn-delete:hover { background: #e74c3c; color: white; border-color: #e74c3c; }

        /* EMPTY STATE */
        .empty-state { text-align: center; padding: 48px 20px; color: #aaa; }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }
        .empty-state p { font-size: 14px; }

        /* FOOTER INFO */
        .table-footer { padding: 12px 20px; font-size: 13px; color: #888; border-top: 1px solid #f0f0f0; }

        /* MODAL */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); z-index: 1000; align-items: center; justify-content: center; }
        .modal-overlay.show { display: flex; }
        .modal-box { background: white; border-radius: 10px; padding: 28px; width: 420px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); }
        .modal-box h4 { font-size: 18px; margin-bottom: 12px; color: #333; }
        .modal-box p { font-size: 14px; color: #666; margin-bottom: 24px; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
        .btn-cancel-modal { padding: 8px 20px; border: 1px solid #ddd; border-radius: 6px; background: white; cursor: pointer; font-size: 14px; }
        .btn-confirm-delete { padding: 8px 20px; background: #e74c3c; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; text-decoration: none; }
        .btn-confirm-delete:hover { background: #c0392b; }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-logo"><span>📚</span> Thư viện</div>
        <div class="sidebar-menu">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a>
                <% if (isAdmin) { %>
                <a href="<%= ctx %>/staffs">👤 Quản lý nhân sự</a>
                <% } %>
                <a href="<%= ctx %>/members" class="active">👥 Thành viên</a>
                <a href="<%= ctx %>/books">📖 Sách</a>
                <a href="<%= ctx %>/bookcopies">📦 Bản sao sách</a>
                <a href="#">🏷️ Thể loại</a>
                <a href="<%= ctx %>/authors">✍️ Tác giả</a>
                <a href="<%= ctx %>/publishers">🏢 Nhà xuất bản</a>
                <% if (!isAdmin) { %>
                <a href="<%= ctx %>/loan?action=list">📋 Mượn/Trả</a>
                <a href="<%= ctx %>/fines?action=list">💰 Phạt</a>
                <% } %>
                <a href="<%= ctx %>/loan?action=logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- MAIN -->
    <div class="main">
        <!-- TOPBAR -->
        <div class="topbar">
            <h2>👥 Quản lý Thành viên</h2>
            <div class="topbar-right">
                👤 <%= staff.getFullName() %>
                <span class="badge-role"><%= staff.getRole() %></span>
                <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- ALERTS -->
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">✅ ${successMsg}</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">⚠️ ${errorMsg}</div>
            </c:if>

            <!-- TOOLBAR -->
            <div class="toolbar">
                <div class="toolbar-left">
                    <form method="get" action="<%= ctx %>/members" class="search-group">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm tên, email, username..."
                               value="${not empty keyword ? keyword : ''}">
                        <button type="submit" class="search-btn">🔍 Tìm</button>
                    </form>
                    <c:if test="${action == 'search'}">
                        <a href="<%= ctx %>/members" style="font-size:13px;color:#4a90d9;text-decoration:none;">✕ Xóa lọc</a>
                    </c:if>
                </div>
                <a href="<%= ctx %>/members?action=add" class="btn-add">➕ Thêm thành viên</a>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <h3>📋 Danh sách thành viên</h3>
                    <c:if test="${not empty memberList}">
                        <span class="count-badge">${memberList.size()} thành viên</span>
                    </c:if>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Loại thành viên</th>
                            <th>Ngày đăng ký</th>
                            <th>Username</th>
                            <th>Trạng thái</th>
                            <th style="text-align:center;">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty memberList}">
                                <c:forEach var="m" items="${memberList}" varStatus="idx">
                                    <tr>
                                        <td style="color:#aaa;">${idx.count}</td>
                                        <td><strong>${m.fullName}</strong></td>
                                        <td>
                                            <c:if test="${not empty m.email}">
                                                <a href="mailto:${m.email}" style="color:#4a90d9;text-decoration:none;">${m.email}</a>
                                            </c:if>
                                        </td>
                                        <td>${m.phone}</td>
                                        <td><span class="badge badge-type">${m.memberType}</span></td>
                                        <td>${m.membershipDate}</td>
                                        <td style="color:#888;">
                                            <c:choose>
                                                <c:when test="${not empty m.username}">👤 ${m.username}</c:when>
                                                <c:otherwise><span style="color:#ddd;">—</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${m.status == 'Hoạt động'}">
                                                    <span class="badge badge-active">● Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-locked">● ${m.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="<%= ctx %>/members?action=edit&id=${m.memberID}" class="btn-edit">✏️ Sửa</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete"
                                               onclick="confirmDelete(${m.memberID}, '${m.fullName}'); return false;">🗑️ Xóa</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="9">
                                        <div class="empty-state">
                                            <div class="icon">👤</div>
                                            <p>Không tìm thấy thành viên nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <c:if test="${not empty memberList}">
                    <div class="table-footer">
                        Hiển thị <strong>${memberList.size()}</strong> thành viên
                        <c:if test="${action == 'search'}"> — kết quả cho "<em>${keyword}</em>"</c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- DELETE MODAL -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h4>⚠️ Xác nhận xóa</h4>
            <p id="deleteModalText">Bạn có chắc muốn xóa thành viên này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            document.getElementById('deleteModalText').textContent =
                'Xóa thành viên "' + name + '"? Hành động này không thể hoàn tác!';
            document.getElementById('deleteConfirmLink').href = '<%= ctx %>/members?action=delete&id=' + id;
            document.getElementById('deleteModal').classList.add('show');
        }
        function closeModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
    </script>
</body>
</html>
