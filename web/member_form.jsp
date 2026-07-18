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
<c:set var="isEdit" value="${not empty member && member.memberID > 0}"/>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>${isEdit ? 'Sửa thành viên' : 'Thêm thành viên'} - Thư viện</title>
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

        /* PASSWORD TOGGLE */
        .pwd-wrap { position: relative; }
        .pwd-toggle { position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: none; border: none; cursor: pointer; color: #aaa; font-size: 16px; }
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
            <h2>${isEdit ? '✏️ Sửa thành viên' : '➕ Thêm thành viên mới'}</h2>
            <div class="topbar-right">
                👤 <%= staff.getFullName() %>
                <span class="badge-role"><%= staff.getRole() %></span>
                <a href="<%= ctx %>/loan?action=logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>

        <!-- CONTENT -->
        <div class="content">

            <!-- BREADCRUMB -->
            <div class="breadcrumb">
                <a href="<%= ctx %>/dashboard">🏠 Dashboard</a> /
                <a href="<%= ctx %>/members">👥 Thành viên</a> /
                <span>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</span>
            </div>

            <!-- FORM CARD -->
            <div class="form-card">
                <div class="form-card-header">
                    <h3>${isEdit ? '✏️ Chỉnh sửa thông tin thành viên' : '➕ Thêm thành viên mới'}</h3>
                </div>
                <div class="form-card-body">
                    <form id="memberForm" method="post" action="<%= ctx %>/members" novalidate>
                        <input type="hidden" name="action" value="${isEdit ? 'update' : 'insert'}">
                        <c:if test="${isEdit}">
                            <input type="hidden" name="memberID" value="${member.memberID}">
                        </c:if>

                        <!-- Thông tin cá nhân -->
                        <div class="section-label">👤 Thông tin cá nhân</div>

                        <!-- Họ tên -->
                        <div class="form-group" id="grp-fullName">
                            <label class="form-label">Họ và tên <span class="required">*</span></label>
                            <input type="text" name="fullName" id="fullName" class="form-control"
                                   placeholder="Nguyễn Văn A"
                                   value="${not empty member ? member.fullName : ''}">
                            <div class="field-error" id="err-fullName">Vui lòng nhập họ và tên.</div>
                        </div>

                        <!-- Email + Phone -->
                        <div class="form-row">
                            <div class="form-group" id="grp-email">
                                <label class="form-label">Email</label>
                                <input type="email" name="email" id="email" class="form-control"
                                       placeholder="example@email.com"
                                       value="${not empty member ? member.email : ''}">
                                <div class="field-error" id="err-email">Email không hợp lệ.</div>
                            </div>
                            <div class="form-group" id="grp-phone">
                                <label class="form-label">Số điện thoại</label>
                                <input type="tel" name="phone" id="phone" class="form-control"
                                       placeholder="0912 345 678"
                                       value="${not empty member ? member.phone : ''}">
                                <div class="field-error" id="err-phone">Số điện thoại không hợp lệ.</div>
                            </div>
                        </div>

                        <!-- Địa chỉ -->
                        <div class="form-group">
                            <label class="form-label">Địa chỉ</label>
                            <input type="text" name="address" class="form-control"
                                   placeholder="123 Đường ABC, Quận 1, TP.HCM"
                                   value="${not empty member ? member.address : ''}">
                        </div>

                        <!-- Loại thành viên + Ngày đăng ký -->
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Loại thành viên</label>
                                <select name="memberType" class="form-control">
                                    <option value="Sinh viên"  ${(empty member || member.memberType == 'Sinh viên')  ? 'selected' : ''}>Sinh viên</option>
                                    <option value="Giáo viên"  ${member.memberType == 'Giáo viên'  ? 'selected' : ''}>Giáo viên</option>
                                    <option value="Cán bộ"     ${member.memberType == 'Cán bộ'     ? 'selected' : ''}>Cán bộ</option>
                                    <option value="Khác"       ${member.memberType == 'Khác'       ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div class="form-group" id="grp-membershipDate">
                                <label class="form-label">Ngày đăng ký <span class="required">*</span></label>
                                <input type="date" name="membershipDate" id="membershipDate" class="form-control"
                                       value="${not empty member ? member.membershipDate : ''}">
                                <div class="field-error" id="err-membershipDate">Vui lòng chọn ngày đăng ký.</div>
                            </div>
                        </div>

                        <!-- Trạng thái -->
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="Hoạt động" ${(empty member || member.status == 'Hoạt động') ? 'selected' : ''}>Hoạt động</option>
                                <option value="Bị khóa"   ${member.status == 'Bị khóa'   ? 'selected' : ''}>Bị khóa</option>
                            </select>
                        </div>

                        <hr class="section-divider">

                        <!-- Tài khoản đăng nhập -->
                        <div class="section-label">🔒 Tài khoản đăng nhập (tuỳ chọn)</div>

                        <div class="form-row">
                            <div class="form-group" id="grp-username">
                                <label class="form-label">Username</label>
                                <input type="text" name="username" id="username" class="form-control"
                                       placeholder="nguyenvana"
                                       value="${not empty member ? member.username : ''}">
                                <div class="form-hint">Để trống nếu không cấp tài khoản.</div>
                                <div class="field-error" id="err-username">Username phải có ít nhất 4 ký tự.</div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">
                                    Mật khẩu
                                    <c:if test="${isEdit}">
                                        <span style="font-weight:400;font-size:12px;color:#aaa;">(để trống = giữ cũ)</span>
                                    </c:if>
                                </label>
                                <div class="pwd-wrap">
                                    <input type="password" name="password" id="password" class="form-control"
                                           placeholder="${isEdit ? '••••••••' : 'Nhập mật khẩu'}"
                                           style="padding-right: 38px;">
                                    <button type="button" class="pwd-toggle" id="togglePwd" title="Hiện/ẩn mật khẩu">👁</button>
                                </div>
                            </div>
                        </div>

                        <!-- BUTTONS -->
                        <div class="btn-row">
                            <a href="<%= ctx %>/members" class="btn-back">✕ Hủy</a>
                            <button type="submit" class="btn-submit">
                                ${isEdit ? '💾 Lưu thay đổi' : '➕ Thêm thành viên'}
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Toggle password
        document.getElementById('togglePwd').addEventListener('click', function () {
            const pwd = document.getElementById('password');
            pwd.type = pwd.type === 'password' ? 'text' : 'password';
            this.textContent = pwd.type === 'password' ? '👁' : '🙈';
        });

        // Auto-fill today for new member
        (function () {
            const d = document.getElementById('membershipDate');
            if (!d.value) d.value = new Date().toISOString().split('T')[0];
        })();

        // Validation
        document.getElementById('memberForm').addEventListener('submit', function (e) {
            let valid = true;
            function setErr(grpId, errId, show) {
                document.getElementById(grpId).classList.toggle('has-error', show);
                document.getElementById(errId).style.display = show ? 'block' : 'none';
                if (show) valid = false;
            }
            setErr('grp-fullName', 'err-fullName',
                document.getElementById('fullName').value.trim() === '');

            const email = document.getElementById('email').value.trim();
            if (email) setErr('grp-email', 'err-email',
                !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email));

            const phone = document.getElementById('phone').value.trim();
            if (phone) setErr('grp-phone', 'err-phone',
                !/^[0-9\s\+\-]{7,15}$/.test(phone));

            setErr('grp-membershipDate', 'err-membershipDate',
                document.getElementById('membershipDate').value === '');

            const uname = document.getElementById('username').value.trim();
            if (uname) setErr('grp-username', 'err-username', uname.length < 4);

            if (!valid) e.preventDefault();
        });
    </script>
</body>
</html>
