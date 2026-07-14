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
<c:set var="isEdit" value="${not empty publisher && publisher.publisherID > 0}"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${isEdit ? 'Sửa NXB' : 'Thêm NXB'} - Thư viện</title>
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

        /* BREADCRUMB */
        .breadcrumb { font-size: 13px; color: #888; margin-bottom: 20px; display: flex; align-items: center; gap: 6px; }
        .breadcrumb a { color: #4a90d9; text-decoration: none; }
        .breadcrumb a:hover { text-decoration: underline; }

        /* FORM CARD */
        .form-card { background: white; border-radius: 10px; box-shadow: 0 1px 4px rgba(0,0,0,0.08); overflow: hidden; max-width: 760px; }
        .form-card-header { padding: 18px 24px; background: #4a90d9; display: flex; align-items: center; gap: 10px; }
        .form-card-header h3 { color: white; font-size: 17px; font-weight: 600; }
        .form-card-body { padding: 28px 24px; }

        /* FORM ELEMENTS */
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 0 20px; }
        @media (max-width: 600px) { .form-row { grid-template-columns: 1fr; } }

        .form-group { margin-bottom: 18px; }
        .form-label { display: block; font-size: 13px; font-weight: 600; color: #555; margin-bottom: 6px; }
        .required { color: #e74c3c; }
        .form-control { width: 100%; padding: 9px 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; color: #333; outline: none; transition: border-color 0.2s; background: white; }
        .form-control:focus { border-color: #4a90d9; box-shadow: 0 0 0 3px rgba(74,144,217,0.15); }
        .form-control::placeholder { color: #bbb; }
        .form-hint { font-size: 12px; color: #aaa; margin-top: 4px; }

        /* ERROR */
        .field-error { font-size: 12px; color: #e74c3c; margin-top: 4px; display: none; }
        .has-error .form-control { border-color: #e74c3c; }
        .has-error .field-error { display: block; }

        /* SECTION DIVIDER */
        .section-divider { border: none; border-top: 1px solid #eee; margin: 22px 0 18px; }
        .section-label { font-size: 12px; font-weight: 700; color: #888; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 16px; display: flex; align-items: center; gap: 6px; }

        /* BUTTONS */
        .btn-row { display: flex; gap: 10px; justify-content: flex-end; margin-top: 24px; }
        .btn-submit { padding: 10px 28px; background: #4a90d9; color: white; border: none; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .btn-submit:hover { background: #357abd; }
        .btn-back { padding: 10px 20px; background: white; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; }
        .btn-back:hover { background: #f5f5f5; }
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
            <h2>${isEdit ? '✏️ Sửa NXB' : '➕ Thêm NXB mới'}</h2>
            <div class="topbar-right">
                👤 <%= staff.getFullName() %>
                <span class="badge-role"><%= staff.getRole() %></span>
                <a href="<%= ctx %>/loan?action=logout" class="btn-logout">🚪 Đăng xuất</a>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- BREADCRUMB -->
            <div class="breadcrumb">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a> /
                <a href="<%= ctx %>/publishers">🏢 Nhà xuất bản</a> /
                <span>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</span>
            </div>

            <!-- FORM CARD -->
            <div class="form-card">
                <div class="form-card-header">
                    <h3>${isEdit ? '✏️ Chỉnh sửa thông tin NXB' : '➕ Thêm NXB mới'}</h3>
                </div>
                <div class="form-card-body">
                    <form id="publisherForm" method="post" action="<%= ctx %>/publishers" novalidate>
                        <input type="hidden" name="action" value="${isEdit ? 'update' : 'insert'}">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="publisherID" value="${publisher.publisherID}">
                        </c:if>

                        <div class="section-label">🏢 Thông tin cơ bản</div>

                        <div class="form-group" id="grp-publisherName">
                            <label class="form-label">Tên nhà xuất bản <span class="required">*</span></label>
                            <input type="text" name="publisherName" id="publisherName" class="form-control"
                                   placeholder="NXB Trẻ, NXB Kim Đồng..."
                                   value="${not empty publisher ? publisher.publisherName : ''}">
                            <div class="field-error" id="err-publisherName">Vui lòng nhập tên nhà xuất bản.</div>
                        </div>

                        <div class="form-group" id="grp-address">
                            <label class="form-label">Địa chỉ</label>
                            <input type="text" name="address" id="address" class="form-control"
                                   placeholder="161B Lý Chính Thắng, TP.HCM"
                                   value="${not empty publisher ? publisher.address : ''}">
                        </div>

                        <div class="form-row">
                            <div class="form-group" id="grp-email">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" id="email" class="form-control"
                                       placeholder="contact@nxb.com"
                                       value="${not empty publisher ? publisher.email : ''}">
                                <div class="field-error" id="err-email">Email không hợp lệ.</div>
                            </div>
                            <div class="form-group" id="grp-phone">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="phone" id="phone" class="form-control"
                                       placeholder="028 1234 5678"
                                       value="${not empty publisher ? publisher.phone : ''}">
                            </div>
                        </div>

                        <!-- BUTTONS -->
                        <div class="btn-row">
                            <a href="<%= ctx %>/publishers" class="btn-back">✕ Hủy</a>
                            <button type="submit" class="btn-submit">
                                ${isEdit ? '💾 Lưu thay đổi' : '➕ Thêm NXB'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Validation
        document.getElementById('publisherForm').addEventListener('submit', function (e) {
            let valid = true;
            function setErr(grpId, errId, show) {
                document.getElementById(grpId).classList.toggle('has-error', show);
                document.getElementById(errId).style.display = show ? 'block' : 'none';
                if (show) valid = false;
            }
            
            // Name required
            setErr('grp-publisherName', 'err-publisherName',
                document.getElementById('publisherName').value.trim() === '');

            // Email format
            const email = document.getElementById('email').value.trim();
            if (email) setErr('grp-email', 'err-email',
                !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email));

            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
