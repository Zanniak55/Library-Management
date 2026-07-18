<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Tài khoản của tôi");
    request.setAttribute("activePage", "profile");
%>
<jsp:include page="/includes/user_header.jsp" />

<div style="display:grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
    <!-- THÔNG TIN TÀI KHOẢN -->
    <div class="card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
        <h3 style="margin-top:0; margin-bottom:20px; color:#1e293b; font-size:16px; border-bottom:1px solid #f1f5f9; padding-bottom:12px;">Thông tin cá nhân</h3>
        
        <div style="display:grid; gap:16px;">
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Họ và tên</div>
                <div style="font-weight:600; color:#1e293b; font-size:16px;">${member.fullName}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Tên đăng nhập</div>
                <div style="color:#334155; font-weight:500;">${member.username}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Email</div>
                <div style="color:#334155; font-weight:500;">${member.email}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Số điện thoại</div>
                <div style="color:#334155; font-weight:500;">${member.phone}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Loại thẻ</div>
                <div style="color:#b45309; font-weight:600;">${member.memberType}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Ngày đăng ký</div>
                <div style="color:#334155; font-weight:500;">${member.membershipDate}</div>
            </div>
        </div>
    </div>

    <!-- ĐỔI MẬT KHẨU -->
    <div class="card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
        <h3 style="margin-top:0; margin-bottom:20px; color:#1e293b; font-size:16px; border-bottom:1px solid #f1f5f9; padding-bottom:12px;">Đổi mật khẩu</h3>
        
        <c:if test="${not empty error}">
            <div style="background:#fee2e2; color:#ef4444; padding:12px; border-radius:8px; margin-bottom:16px; font-size:14px;">${error}</div>
        </c:if>
        <c:if test="${not empty msg}">
            <div style="background:#dcfce7; color:#166534; padding:12px; border-radius:8px; margin-bottom:16px; font-size:14px;">${msg}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/profile" method="POST">
            <input type="hidden" name="action" value="change-password">
            <div style="margin-bottom:16px;">
                <label style="display:block; font-size:13px; color:#475569; margin-bottom:4px;">Mật khẩu hiện tại</label>
                <input type="password" name="oldPassword" required
                       style="width:100%; padding:10px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px;">
            </div>
            <div style="margin-bottom:16px;">
                <label style="display:block; font-size:13px; color:#475569; margin-bottom:4px;">Mật khẩu mới</label>
                <input type="password" name="newPassword" required minlength="6"
                       style="width:100%; padding:10px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px;">
            </div>
            <div style="margin-bottom:24px;">
                <label style="display:block; font-size:13px; color:#475569; margin-bottom:4px;">Xác nhận mật khẩu mới</label>
                <input type="password" name="confirmPassword" required minlength="6"
                       style="width:100%; padding:10px 12px; border:1px solid #cbd5e1; border-radius:6px; font-size:14px;">
            </div>
            <button type="submit" style="width:100%; padding:12px; background:var(--primary); color:white; border:none; border-radius:8px; font-weight:600; cursor:pointer; font-size:14px; transition:background 0.2s;">
                Cập nhật mật khẩu
            </button>
        </form>
    </div>
</div>

<jsp:include page="/includes/user_footer.jsp" />
