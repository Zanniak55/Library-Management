<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Chi tiết mượn sách");
    request.setAttribute("activePage", "loans");
%>
<jsp:include page="/includes/user_header.jsp" />

<div style="margin-bottom:20px;">
    <a href="${pageContext.request.contextPath}/user/loans" style="color:#64748b; text-decoration:none; font-size:14px; display:inline-flex; align-items:center; gap:8px;">
        <span>←</span> Quay lại danh sách
    </a>
</div>

<div style="display:grid; grid-template-columns: 1fr 2fr; gap: 24px; margin-bottom: 24px;">
    <!-- THÔNG TIN PHIẾU -->
    <div class="card" style="background:white; padding:24px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05);">
        <h3 style="margin-top:0; margin-bottom:20px; color:#1e293b; font-size:16px; border-bottom:1px solid #f1f5f9; padding-bottom:12px;">Thông tin chung</h3>
        
        <div style="display:grid; gap:16px;">
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Mã phiếu</div>
                <div style="font-weight:600; color:#1e293b; font-size:16px;">#<c:out value="${String.format('%05d', transaction.transactionID)}"/></div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Ngày mượn</div>
                <div style="color:#334155; font-weight:500;">${transaction.borrowDate}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Hạn trả</div>
                <div style="color:#334155; font-weight:500;">${transaction.dueDate}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Ngày trả</div>
                <div style="color:#334155; font-weight:500;">${not empty transaction.returnDate ? transaction.returnDate : '—'}</div>
            </div>
            <div>
                <div style="color:#64748b; font-size:13px; margin-bottom:4px;">Trạng thái</div>
                <c:choose>
                    <c:when test="${transaction.status == 'Đang mượn'}">
                        <span style="background:#eff6ff; color:#1d4ed8; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Đang mượn</span>
                    </c:when>
                    <c:when test="${transaction.status == 'Đã trả'}">
                        <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Đã trả</span>
                    </c:when>
                    <c:otherwise>
                        <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Quá hạn</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- DANH SÁCH CUỐN SÁCH -->
    <div class="card" style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); overflow:hidden;">
        <div style="padding:24px; border-bottom:1px solid #f1f5f9;">
            <h3 style="margin:0; color:#1e293b; font-size:16px;">Sách đã mượn</h3>
        </div>
        
        <table style="width:100%; border-collapse:collapse; text-align:left;">
            <thead>
                <tr style="background:#f8fafc; border-bottom:1px solid #e2e8f0; color:#475569; font-size:13px; text-transform:uppercase;">
                    <th style="padding:12px 24px;">Mã sách (Mã vạch)</th>
                    <th style="padding:12px 24px;">Tựa sách</th>
                    <th style="padding:12px 24px;">ISBN</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${details}">
                    <tr style="border-bottom:1px solid #f1f5f9;">
                        <td style="padding:16px 24px; font-family:monospace; color:#475569;">${item[1]}</td>
                        <td style="padding:16px 24px; font-weight:600; color:#1e293b;">${item[2]}</td>
                        <td style="padding:16px 24px; color:#64748b;">${item[3]}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="/includes/user_footer.jsp" />
