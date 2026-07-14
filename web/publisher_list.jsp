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
    <title>Quản lý Nhà xuất bản - Thư viện</title>
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
        .badge-role { background: #e74c3c; color: white; padding: 2px 8px; border-radius: 12px; font-size: 12px; }
        .btn-logout { background: none; border: 1px solid #ccc; padding: 6px 14px; border-radius: 4px; cursor: pointer; color: #e74c3c; font-size: 13px; text-decoration: none; }
        .btn-logout:hover { background: #fdf5f5; }

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
        
        .btn-add { padding: 8px 18px; background: #4a90d9; color: white; border: none; border-radius: 6px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn-add:hover { background: #357abd; }

        /* ALERT */
        .alert { padding: 10px 16px; border-radius: 6px; margin-bottom: 16px; font-size: 14px; }
        .alert-success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
        .alert-danger  { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }

        /* TABLE CARD */
        .table-card { background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; }
        .table-card-header { padding: 16px 20px; border-bottom: 1px solid #eee; display: flex; align-items: center; justify-content: space-between; }
        .table-card-header-left { display: flex; align-items: center; gap: 8px; }
        .table-card-header h3 { font-size: 16px; color: #333; font-weight: 600; }

        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        thead { background: #f8f9fa; }
        thead th { padding: 12px 16px; text-align: left; color: #555; font-weight: 600; font-size: 13px; border-bottom: 2px solid #eee; white-space: nowrap; }
        tbody tr { border-bottom: 1px solid #f5f5f5; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:nth-child(even) { background: #fafafa; }
        tbody tr:hover { background: #f0f6ff; }
        tbody td { padding: 12px 16px; color: #333; vertical-align: middle; }

        /* ACTION BUTTONS */
        .btn-edit { padding: 4px 10px; color: #4a90d9; border: 1px solid #4a90d9; border-radius: 4px; font-size: 14px; text-decoration: none; display: inline-block; cursor: pointer; transition: all 0.2s; }
        .btn-edit:hover { background: #4a90d9; color: white; }
        .btn-delete { padding: 4px 10px; color: #e74c3c; border: 1px solid #e74c3c; border-radius: 4px; font-size: 14px; text-decoration: none; display: inline-block; cursor: pointer; transition: all 0.2s; }
        .btn-delete:hover { background: #e74c3c; color: white; }

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
            <a href="<%= ctx %>/members">👥 Thành viên</a>
            <a href="<%= ctx %>/books">📖 Sách</a>
            <a href="<%= ctx %>/bookcopies">📦 Bản sao sách</a>
            <a href="#">🏷️ Thể loại</a>
            <a href="#">✍️ Tác giả</a>
            <a href="<%= ctx %>/publishers" class="active">🏢 Nhà xuất bản</a>
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
            <h2>Quản lý NXB</h2>
            <div class="topbar-right">
                👤 <%= staff.getFullName() %>
                <span class="badge-role"><%= staff.getRole() %></span>
                <a href="<%= ctx %>/loan?action=logout" class="btn-logout">🚪 Đăng xuất</a>
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

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>🏢 Danh sách nhà xuất bản</h3>
                    </div>
                    <div>
                        <a href="<%= ctx %>/publishers?action=add" class="btn-add">➕ Thêm NXB</a>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên NXB</th>
                            <th>Địa chỉ</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th style="text-align:center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty publishers}">
                                <c:forEach var="p" items="${publishers}">
                                    <tr>
                                        <td>${p.publisherID}</td>
                                        <td>${p.publisherName}</td>
                                        <td>${p.address}</td>
                                        <td>${p.phone}</td>
                                        <td>${p.email}</td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="<%= ctx %>/publishers?action=edit&id=${p.publisherID}" class="btn-edit" title="Sửa">✏️</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete" title="Xóa"
                                               onclick="confirmDelete(${p.publisherID}, '${p.publisherName}'); return false;">🗑️</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <div class="icon">🏢</div>
                                            <p>Không tìm thấy nhà xuất bản nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- DELETE MODAL -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h4>⚠️ Xác nhận xóa</h4>
            <p id="deleteModalText">Bạn có chắc muốn xóa nhà xuất bản này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            document.getElementById('deleteModalText').textContent =
                'Xóa nhà xuất bản "' + name + '"? Hành động này có thể ảnh hưởng tới các sách thuộc nhà xuất bản này!';
            document.getElementById('deleteConfirmLink').href = '<%= ctx %>/publishers?action=delete&id=' + id;
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
