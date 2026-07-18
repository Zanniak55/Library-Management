<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%
    request.setAttribute("pageTitle", "Tổng quan");
    request.setAttribute("activePage", "dashboard");
%>
<jsp:include page="/includes/user_header.jsp" />

<div class="stats-grid" style="display:grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-bottom: 30px;">
    <!-- Sách đang mượn -->
    <div class="stat-card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); border-left:4px solid var(--primary);">
        <div style="color:#64748b; font-size:14px; font-weight:600; text-transform:uppercase; margin-bottom:8px;">Sách đang mượn</div>
        <div style="font-size:32px; font-weight:700; color:#1e293b; margin-bottom:12px;">${activeLoanCount}</div>
        <a href="${pageContext.request.contextPath}/user/loans" style="color:var(--primary); text-decoration:none; font-size:14px; font-weight:500;">Xem chi tiết →</a>
    </div>

    <!-- Tổng lần mượn -->
    <div class="stat-card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); border-left:4px solid #10b981;">
        <div style="color:#64748b; font-size:14px; font-weight:600; text-transform:uppercase; margin-bottom:8px;">Tổng lần mượn</div>
        <div style="font-size:32px; font-weight:700; color:#1e293b; margin-bottom:12px;">${totalLoanCount}</div>
        <div style="color:#64748b; font-size:14px;">kể từ khi tham gia</div>
    </div>

    <!-- Phạt chưa đóng -->
    <div class="stat-card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); border-left:4px solid #ef4444;">
        <div style="color:#64748b; font-size:14px; font-weight:600; text-transform:uppercase; margin-bottom:8px;">Phạt chưa đóng</div>
        <div style="font-size:32px; font-weight:700; color:#1e293b; margin-bottom:4px;">
            <fmt:formatNumber value="${totalUnpaidAmount}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
        </div>
        <div style="color:#ef4444; font-size:14px; font-weight:500; margin-bottom:12px;">${unpaidFineCount} phiếu phạt</div>
        <a href="${pageContext.request.contextPath}/user/fines" style="color:#ef4444; text-decoration:none; font-size:14px; font-weight:500;">Thanh toán ngay →</a>
    </div>
</div>

<div style="display:grid; grid-template-columns: 2fr 1fr; gap: 24px;">
    <div class="welcome-card" style="background:white; padding:32px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
        <h2 style="font-size:24px; color:#1e293b; margin-bottom:16px;">Xin chào, ${user.fullName}! 👋</h2>
        <p style="color:#64748b; margin-bottom:24px; line-height:1.6;">Chào mừng bạn đến với Cổng thông tin độc giả của Thư viện. Tại đây, bạn có thể dễ dàng tra cứu sách, theo dõi lịch sử mượn trả, và quản lý thông tin tài khoản cá nhân của mình.</p>
        
        <div style="display:flex; gap:32px; flex-wrap:wrap; background:#f8fafc; padding:20px; border-radius:8px;">
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Loại thành viên</div>
                <div style="font-weight:600; color:#b45309;">${user.memberType}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Ngày đăng ký</div>
                <div style="font-weight:600; color:#334155;">${user.membershipDate}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Email liên hệ</div>
                <div style="font-weight:600; color:#334155;">${user.email}</div>
            </div>
        </div>
    </div>

    <!-- Sách mượn nhiều nhất -->
    <div class="top-books-card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
        <h3 style="margin-top:0; margin-bottom:16px; color:#1e293b; font-size:16px; display:flex; justify-content:space-between; align-items:center;">
            Sách được mượn nhiều
            <span style="font-size:18px;">🔥</span>
        </h3>
        <div style="display:flex; flex-direction:column; gap:12px;">
            <c:forEach var="tb" items="${topBooks}">
                <div style="display:flex; align-items:center; gap:12px; padding-bottom:12px; border-bottom:1px solid #f1f5f9;">
                    <div style="width:40px; height:40px; background:#fef3c7; color:#d97706; border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:bold;">
                        📖
                    </div>
                    <div>
                        <div style="font-weight:600; color:#334155; font-size:14px; margin-bottom:2px;">${tb[0]}</div>
                        <div style="color:#64748b; font-size:12px;">${tb[1]} lượt mượn</div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty topBooks}">
                <div style="color:#64748b; font-size:13px;">Chưa có dữ liệu</div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="/includes/user_footer.jsp" />
