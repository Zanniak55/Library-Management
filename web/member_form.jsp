<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:set var="isEdit" value="${not empty member && member.memberID > 0}"/>
    <title>${isEdit ? 'Sửa thành viên' : 'Thêm thành viên'} – Thư viện</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        :root {
            --primary: #4f46e5; --primary-h: #4338ca;
            --accent: #06b6d4;
            --bg-body: #0f172a; --bg-card: #1e293b;
            --text-main: #f1f5f9; --text-muted: #94a3b8;
            --border: #334155; --danger: #ef4444;
            --radius: .75rem;
        }
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Segoe UI', system-ui, sans-serif; background: var(--bg-body); color: var(--text-main); min-height: 100vh; margin: 0; }

        .page-wrapper { max-width: 740px; margin: 2rem auto; padding: 0 1.25rem 4rem; }

        .breadcrumb-custom { display: flex; align-items: center; gap: .4rem; font-size: .85rem; color: var(--text-muted); margin-bottom: 1.4rem; }
        .breadcrumb-custom a { color: var(--accent); text-decoration: none; }
        .breadcrumb-custom a:hover { text-decoration: underline; }

        .form-card { background: var(--bg-card); border-radius: var(--radius); box-shadow: 0 8px 32px rgba(0,0,0,.4); overflow: hidden; }
        .card-header-custom { background: linear-gradient(135deg, var(--primary) 0%, var(--accent) 100%); padding: 1.3rem 1.8rem; display: flex; align-items: center; gap: .7rem; }
        .card-header-custom h4 { margin: 0; font-size: 1.12rem; font-weight: 700; color: #fff; }
        .card-body-custom { padding: 1.8rem; }

        .form-group { margin-bottom: 1.2rem; }
        .form-label-custom { display: block; font-size: .82rem; font-weight: 600; color: var(--text-muted); margin-bottom: .42rem; letter-spacing: .04em; text-transform: uppercase; }
        .required-star { color: var(--danger); }
        .form-control-custom, .form-select-custom {
            width: 100%; background: rgba(255,255,255,.05); border: 1.5px solid var(--border);
            border-radius: .5rem; color: var(--text-main); padding: .62rem 1rem; font-size: .95rem;
            transition: border-color .2s, box-shadow .2s; outline: none;
        }
        .form-control-custom:focus, .form-select-custom:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79,70,229,.2); }
        .form-control-custom::placeholder { color: var(--text-muted); }
        .form-select-custom {
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='%2394a3b8' d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 01.753 1.659l-4.796 5.48a1 1 0 01-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat; background-position: right .9rem center; background-size: 14px; padding-right: 2.5rem;
        }
        .form-select-custom option { background: var(--bg-card); }

        .field-hint { font-size: .78rem; color: var(--text-muted); margin-top: .3rem; }

        .row-2col { display: grid; grid-template-columns: 1fr 1fr; gap: 0 1.2rem; }
        @media (max-width: 540px) { .row-2col { grid-template-columns: 1fr; } }

        .section-divider { border: none; border-top: 1px solid var(--border); margin: 1.4rem 0 1.2rem; }
        .section-label { font-size: .78rem; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; color: var(--text-muted); margin-bottom: 1rem; display: flex; align-items: center; gap: .4rem; }

        .field-error { color: var(--danger); font-size: .79rem; margin-top: .3rem; display: none; }
        .has-error .form-control-custom, .has-error .form-select-custom { border-color: var(--danger); }
        .has-error .field-error { display: block; }

        .btn-row { display: flex; gap: .75rem; margin-top: 1.8rem; justify-content: flex-end; flex-wrap: wrap; }
        .btn-submit { background: linear-gradient(135deg, var(--primary), var(--accent)); color: #fff; border: none; border-radius: .5rem; padding: .65rem 1.6rem; font-weight: 600; font-size: .95rem; cursor: pointer; display: flex; align-items: center; gap: .4rem; transition: opacity .2s, transform .15s; }
        .btn-submit:hover { opacity: .88; transform: translateY(-1px); }
        .btn-cancel { background: rgba(255,255,255,.06); color: var(--text-muted); border: 1px solid var(--border); border-radius: .5rem; padding: .65rem 1.3rem; font-weight: 500; font-size: .95rem; text-decoration: none; display: flex; align-items: center; gap: .4rem; transition: background .18s; }
        .btn-cancel:hover { background: rgba(255,255,255,.1); color: var(--text-main); }

        footer { text-align: center; padding: 1.5rem; color: var(--text-muted); font-size: .82rem; margin-top: 2rem; }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="page-wrapper">

    <%-- Breadcrumb --%>
    <div class="breadcrumb-custom">
        <a href="MemberServlet"><i class="bi bi-people-fill"></i> Thành viên</a>
        <i class="bi bi-chevron-right"></i>
        <span>${isEdit ? 'Chỉnh sửa' : 'Thêm mới'}</span>
    </div>

    <div class="form-card">

        <%-- Header --%>
        <div class="card-header-custom">
            <i class="bi bi-person-${isEdit ? 'gear' : 'plus-fill'}" style="font-size:1.4rem;color:#fff;"></i>
            <h4>${isEdit ? 'Chỉnh sửa thông tin thành viên' : 'Thêm thành viên mới'}</h4>
        </div>

        <%-- Body --%>
        <div class="card-body-custom">
            <form id="memberForm" method="post" action="MemberServlet" novalidate>
                <input type="hidden" name="action" value="${isEdit ? 'update' : 'insert'}">
                <c:if test="${isEdit}">
                    <input type="hidden" name="memberID" value="${member.memberID}">
                </c:if>

                <%-- ── Thông tin cá nhân ── --%>
                <div class="section-label"><i class="bi bi-person-lines-fill"></i> Thông tin cá nhân</div>

                <%-- Họ tên --%>
                <div class="form-group" id="grp-fullName">
                    <label class="form-label-custom" for="fullName">
                        Họ và tên <span class="required-star">*</span>
                    </label>
                    <input type="text" id="fullName" name="fullName"
                           class="form-control-custom"
                           placeholder="Nguyễn Văn A"
                           value="${not empty member ? member.fullName : ''}">
                    <div class="field-error" id="err-fullName">Vui lòng nhập họ và tên.</div>
                </div>

                <%-- Email + Phone --%>
                <div class="row-2col">
                    <div class="form-group" id="grp-email">
                        <label class="form-label-custom" for="email">Email</label>
                        <input type="email" id="email" name="email"
                               class="form-control-custom"
                               placeholder="example@email.com"
                               value="${not empty member ? member.email : ''}">
                        <div class="field-error" id="err-email">Email không hợp lệ.</div>
                    </div>
                    <div class="form-group" id="grp-phone">
                        <label class="form-label-custom" for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone"
                               class="form-control-custom"
                               placeholder="0912 345 678"
                               value="${not empty member ? member.phone : ''}">
                        <div class="field-error" id="err-phone">Số điện thoại không hợp lệ (7–15 ký tự số).</div>
                    </div>
                </div>

                <%-- Địa chỉ --%>
                <div class="form-group">
                    <label class="form-label-custom" for="address">Địa chỉ</label>
                    <input type="text" id="address" name="address"
                           class="form-control-custom"
                           placeholder="123 Đường ABC, Quận 1, TP.HCM"
                           value="${not empty member ? member.address : ''}">
                </div>

                <%-- MemberType + MembershipDate --%>
                <div class="row-2col">
                    <div class="form-group">
                        <label class="form-label-custom" for="memberType">Loại thành viên</label>
                        <select id="memberType" name="memberType" class="form-select-custom">
                            <option value="Sinh viên"   ${(empty member || member.memberType == 'Sinh viên')   ? 'selected' : ''}>Sinh viên</option>
                            <option value="Giáo viên"   ${member.memberType == 'Giáo viên'   ? 'selected' : ''}>Giáo viên</option>
                            <option value="Cán bộ"      ${member.memberType == 'Cán bộ'      ? 'selected' : ''}>Cán bộ</option>
                            <option value="Khác"        ${member.memberType == 'Khác'        ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                    <div class="form-group" id="grp-membershipDate">
                        <label class="form-label-custom" for="membershipDate">
                            Ngày đăng ký <span class="required-star">*</span>
                        </label>
                        <input type="date" id="membershipDate" name="membershipDate"
                               class="form-control-custom"
                               value="${not empty member ? member.membershipDate : ''}">
                        <div class="field-error" id="err-membershipDate">Vui lòng chọn ngày đăng ký.</div>
                    </div>
                </div>

                <%-- Status --%>
                <div class="form-group">
                    <label class="form-label-custom" for="status">Trạng thái</label>
                    <select id="status" name="status" class="form-select-custom">
                        <option value="Hoạt động" ${(empty member || member.status == 'Hoạt động') ? 'selected' : ''}>Hoạt động</option>
                        <option value="Bị khóa"   ${member.status == 'Bị khóa'   ? 'selected' : ''}>Bị khóa</option>
                    </select>
                </div>

                <hr class="section-divider">

                <%-- ── Tài khoản đăng nhập ── --%>
                <div class="section-label"><i class="bi bi-shield-lock-fill"></i> Tài khoản đăng nhập (tuỳ chọn)</div>

                <div class="row-2col">
                    <div class="form-group" id="grp-username">
                        <label class="form-label-custom" for="username">Username</label>
                        <input type="text" id="username" name="username"
                               class="form-control-custom"
                               placeholder="nguyenvana"
                               value="${not empty member ? member.username : ''}">
                        <div class="field-hint">Để trống nếu không cấp tài khoản.</div>
                        <div class="field-error" id="err-username">Username phải có ít nhất 4 ký tự.</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label-custom" for="password">
                            Mật khẩu
                            <c:if test="${isEdit}">
                                <span style="font-weight:400;text-transform:none;letter-spacing:0;"> (để trống = giữ cũ)</span>
                            </c:if>
                        </label>
                        <div style="position:relative;">
                            <input type="password" id="password" name="password"
                                   class="form-control-custom"
                                   placeholder="${isEdit ? '••••••••' : 'Nhập mật khẩu'}"
                                   style="padding-right:2.8rem;">
                            <button type="button" id="togglePwd"
                                    style="position:absolute;right:.75rem;top:50%;transform:translateY(-50%);background:none;border:none;color:var(--text-muted);cursor:pointer;padding:0;">
                                <i class="bi bi-eye-slash-fill" id="eyeIcon"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <%-- Buttons --%>
                <div class="btn-row">
                    <a href="MemberServlet" class="btn-cancel" id="btnCancel">
                        <i class="bi bi-x-circle"></i> Hủy
                    </a>
                    <button type="submit" class="btn-submit" id="btnSubmit">
                        <i class="bi bi-${isEdit ? 'floppy2-fill' : 'person-plus-fill'}"></i>
                        ${isEdit ? 'Lưu thay đổi' : 'Thêm thành viên'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<footer>© 2024 Hệ thống Quản lý Thư viện – Member B</footer>

<script>
// ── Toggle password visibility ────────────────────────
document.getElementById('togglePwd').addEventListener('click', function() {
    const pwd = document.getElementById('password');
    const icon = document.getElementById('eyeIcon');
    if (pwd.type === 'password') {
        pwd.type = 'text';
        icon.className = 'bi bi-eye-fill';
    } else {
        pwd.type = 'password';
        icon.className = 'bi bi-eye-slash-fill';
    }
});

// ── Auto-fill today as MembershipDate for new member ──
(function() {
    const d = document.getElementById('membershipDate');
    if (!d.value) d.value = new Date().toISOString().split('T')[0];
})();

// ── Client-side validation ────────────────────────────
document.getElementById('memberForm').addEventListener('submit', function(e) {
    let valid = true;

    function setErr(grpId, errId, show) {
        document.getElementById(grpId).classList.toggle('has-error', show);
        document.getElementById(errId).style.display = show ? 'block' : 'none';
        if (show) valid = false;
    }

    // Họ tên – bắt buộc
    setErr('grp-fullName', 'err-fullName',
           document.getElementById('fullName').value.trim() === '');

    // Email – nếu có phải đúng định dạng
    const email = document.getElementById('email').value.trim();
    if (email !== '') {
        setErr('grp-email', 'err-email',
               !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email));
    }

    // Phone – nếu có phải là số
    const phone = document.getElementById('phone').value.trim();
    if (phone !== '') {
        setErr('grp-phone', 'err-phone',
               !/^[0-9\s\+\-]{7,15}$/.test(phone));
    }

    // Ngày đăng ký – bắt buộc
    setErr('grp-membershipDate', 'err-membershipDate',
           document.getElementById('membershipDate').value === '');

    // Username – nếu có phải >= 4 ký tự
    const uname = document.getElementById('username').value.trim();
    if (uname !== '') {
        setErr('grp-username', 'err-username', uname.length < 4);
    }

    if (!valid) e.preventDefault();
});
</script>
</body>
</html>
