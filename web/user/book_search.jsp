<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Tra cứu sách");
    request.setAttribute("activePage", "books");
%>
<jsp:include page="/includes/user_header.jsp" />

<!-- HEADER ACTION BAR -->
<div class="table-card-header" style="background:white; padding:20px; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); margin-bottom:24px; display:flex; justify-content:space-between; align-items:center;">
    <div class="table-card-header-left" style="display:flex; align-items:center; gap:16px;">
        <h3 style="font-size:18px; color:#1e293b; margin:0;">📚 Danh mục sách</h3>
    </div>
    <div class="table-card-header-right">
        <form action="${pageContext.request.contextPath}/user/books" method="GET" style="display:flex; gap:8px; align-items:center;">
            <input type="text" name="keyword" class="search-input"
                   style="padding:10px 16px; border:1px solid #cbd5e1; border-radius:8px; width:280px; font-size:14px; outline:none;"
                   placeholder="Tìm tên sách, ISBN, tác giả..."
                   value="${not empty keyword ? keyword : ''}">
            <button type="submit" class="search-btn" style="padding:10px 16px; background:var(--primary); color:white; border:none; border-radius:8px; font-weight:500; cursor:pointer;">🔍 Tìm</button>
        </form>
        <c:if test="${not empty keyword}">
            <a href="${pageContext.request.contextPath}/user/books" style="font-size:13px;color:var(--primary);text-decoration:none; display:block; text-align:right; margin-top:4px;">✕ Xóa bộ lọc</a>
        </c:if>
    </div>
</div>

<!-- TABLE CARD -->
<div class="table-card" style="background:white; border-radius:12px; box-shadow:0 2px 10px rgba(0,0,0,0.05); overflow:hidden;">
    <table style="width:100%; border-collapse:collapse; text-align:left;">
        <thead>
            <tr style="background:#f8fafc; border-bottom:1px solid #e2e8f0; color:#475569; font-size:13px; text-transform:uppercase;">
                <th style="padding:16px;">#</th>
                <th style="padding:16px;">ISBN</th>
                <th style="padding:16px;">Tên sách</th>
                <th style="padding:16px;">Tác giả</th>
                <th style="padding:16px;">Thể loại</th>
                <th style="padding:16px;">Nhà XB</th>
                <th style="padding:16px;">Năm XB</th>
                <th style="padding:16px; text-align:center;">Trạng thái</th>
                <th style="padding:16px; text-align:center;">Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty books}">
                    <c:forEach var="b" items="${books}" varStatus="st">
                        <tr style="border-bottom:1px solid #f1f5f9; transition:background 0.2s;">
                            <td style="padding:16px; color:#94a3b8;">${(currentPage - 1) * 12 + st.index + 1}</td>
                            <td style="padding:16px;"><code>${b.isbn}</code></td>
                            <td style="padding:16px; font-weight:600; color:#1e293b;">${b.title}</td>
                            <td style="padding:16px; color:#475569;">${not empty b.authors ? b.authors : '—'}</td>
                            <td style="padding:16px;">
                                <span style="background:#f1f5f9; color:#475569; padding:4px 8px; border-radius:6px; font-size:12px; font-weight:500;">
                                    ${b.categoryName != null ? b.categoryName : '—'}
                                </span>
                            </td>
                            <td style="padding:16px; color:#475569;">${b.publisherName != null ? b.publisherName : '—'}</td>
                            <td style="padding:16px; color:#475569;">${b.publicationYear}</td>
                            <td style="padding:16px; text-align:center;">
                                <c:choose>
                                    <c:when test="${b.availableQuantity > 0}">
                                        <span style="background:#dcfce7; color:#166534; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Sẵn sàng mượn (${b.availableQuantity}/${b.totalQuantity})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background:#fee2e2; color:#991b1b; padding:4px 8px; border-radius:12px; font-size:12px; font-weight:600;">Hết sách (${b.totalQuantity} quyển)</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="padding:16px; text-align:center;">
                                <c:if test="${b.availableQuantity > 0}">
                                    <form action="${pageContext.request.contextPath}/user/reserve" method="POST" style="margin:0;">
                                        <input type="hidden" name="isbn" value="${b.isbn}">
                                        <button type="submit" style="padding:6px 12px; background:var(--primary); color:white; border:none; border-radius:6px; font-size:13px; font-weight:500; cursor:pointer; transition:all 0.2s;">
                                            Đăng ký mượn
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="9" style="padding:40px; text-align:center; color:#64748b;">
                            <div style="font-size:48px; margin-bottom:16px;">📚</div>
                            <div>Không tìm thấy quyển sách nào.</div>
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <c:if test="${totalPages > 1}">
        <div class="pagination" style="display:flex; justify-content:center; gap:8px; padding:20px; border-top:1px solid #f1f5f9;">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="?page=${i}${not empty keyword ? '&keyword=' += keyword : ''}" 
                   style="display:flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:8px; text-decoration:none; font-weight:500; font-size:14px; transition:all 0.2s; ${i == currentPage ? 'background:var(--primary);color:white;' : 'background:#f1f5f9;color:#475569;'}">
                    ${i}
                </a>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="/includes/user_footer.jsp" />
