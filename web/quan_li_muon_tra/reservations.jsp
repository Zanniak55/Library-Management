<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Duyệt Đăng Ký Mượn");
%>
<jsp:include page="/includes/header.jsp" />

<div class="content-header">
    <h2>Duyệt Đăng Ký Mượn Sách</h2>
    <p>Danh sách các độc giả đăng ký mượn sách trực tuyến</p>
</div>

<!-- ALERTS -->
<c:if test="${not empty sessionScope.errorMsg}">
    <div class="alert alert-danger" style="margin-bottom: 20px;">⚠️ ${sessionScope.errorMsg}</div>
    <c:remove var="errorMsg" scope="session"/>
</c:if>
<c:if test="${not empty sessionScope.successMsg}">
    <div class="alert alert-success" style="margin-bottom: 20px;">✅ ${sessionScope.successMsg}</div>
    <c:remove var="successMsg" scope="session"/>
</c:if>

<div class="table-card">
    <div class="table-card-header">
        <div class="table-card-header-left">
            <h3>Danh sách duyệt</h3>
        </div>
    </div>
    <table>
        <thead>
            <tr>
                <th>Mã ĐK</th>
                <th>Người đăng ký</th>
                <th>Tên sách</th>
                <th>Ngày đăng ký</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="r" items="${reservations}">
                        <tr>
                            <td>#${String.format('%05d', r.reservationID)}</td>
                            <td class="fw-bold">${r.memberName}</td>
                            <td>${r.bookTitle} <br><small class="text-muted">ISBN: ${r.isbn}</small></td>
                            <td>${r.reservationDate}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/reservations" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="approve">
                                    <input type="hidden" name="reservationID" value="${r.reservationID}">
                                    <button type="submit" class="btn-edit" style="cursor:pointer; border:none;">Duyệt</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/reservations" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="reservationID" value="${r.reservationID}">
                                    <button type="submit" class="btn-delete" style="cursor:pointer; border:none; margin-left:4px;">Từ chối</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="5" class="text-center text-muted py-4">Không có yêu cầu mượn sách nào đang chờ duyệt.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="/includes/footer.jsp" />
