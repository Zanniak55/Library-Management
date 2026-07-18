<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Đăng ký mượn sách");
    request.setAttribute("activePage", "reservations");
%>
<jsp:include page="/includes/user_header.jsp" />

<div class="table-card" style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); overflow:hidden;">
    <div style="padding:20px; border-bottom:1px solid #e2e8f0; display:flex; justify-content:space-between; align-items:center;">
        <h3 style="margin:0; color:#1e293b; font-size:18px;">🛒 Sách đang đăng ký mượn</h3>
        <a href="${pageContext.request.contextPath}/user/books" style="padding:8px 16px; background:var(--primary); color:white; border-radius:8px; text-decoration:none; font-size:13px; font-weight:500;">+ Đăng ký thêm</a>
    </div>
    <table style="width:100%; border-collapse:collapse; text-align:left;">
        <thead>
            <tr style="background:#f8fafc; border-bottom:1px solid #e2e8f0; color:#475569; font-size:13px; text-transform:uppercase;">
                <th style="padding:16px;">Mã ĐK</th>
                <th style="padding:16px;">Tên sách</th>
                <th style="padding:16px;">ISBN</th>
                <th style="padding:16px;">Ngày đăng ký</th>
                <th style="padding:16px;">Trạng thái</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="r" items="${reservations}">
                        <tr style="border-bottom:1px solid #f1f5f9;">
                            <td style="padding:16px; font-weight:600; color:#1e293b;">#<c:out value="${String.format('%05d', r.reservationID)}"/></td>
                            <td style="padding:16px; font-weight:600; color:#1e293b;">${r.bookTitle}</td>
                            <td style="padding:16px; color:#475569;"><code>${r.isbn}</code></td>
                            <td style="padding:16px; color:#475569;">${r.reservationDate}</td>
                            <td style="padding:16px;">
                                <c:choose>
                                    <c:when test="${r.status == 'Chờ duyệt'}">
                                        <span style="background:#fef3c7; color:#d97706; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Chờ duyệt</span>
                                    </c:when>
                                    <c:when test="${r.status == 'Đã duyệt'}">
                                        <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Đã duyệt</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">${r.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" style="padding:40px; text-align:center; color:#64748b;">
                            <div style="font-size:48px; margin-bottom:16px;">🛒</div>
                            <div>Bạn chưa đăng ký mượn cuốn sách nào.</div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/user_footer.jsp" />
