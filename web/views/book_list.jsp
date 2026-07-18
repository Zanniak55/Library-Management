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
    boolean isAdmin = "Admin".equals(staff.getRole());
    request.setAttribute("pageTitle", "Quản lý Sách - Thư viện");
    request.setAttribute("activePage", "books");
%>
<jsp:include page="/includes/header.jsp" />

            <!-- ALERTS -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">✅ ${sessionScope.success}</div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">⚠️ ${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- TOOLBAR -->
            <div class="toolbar">
                <div class="toolbar-left">
                    <form action="books" method="get" class="search-group">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm theo tên sách, tác giả, ISBN…"
                               value="${not empty keyword ? keyword : ''}">
                        <button class="search-btn" type="submit">🔍 Tìm</button>
                    </form>
                    <c:if test="${not empty keyword}">
                        <a href="books" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa lọc</a>
                    </c:if>
                </div>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>📖 Danh sách Sách</h3>
                        <span class="count-badge">
                            ${books.size()} sách
                        </span>
                    </div>
                    <div>
                        <a href="books?action=new" class="btn-add">➕ Thêm Sách</a>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>ISBN</th>
                            <th>Tên Sách</th>
                            <th>Tác Giả</th>
                            <th>Thể Loại</th>
                            <th>NXB</th>
                            <th>Năm XB</th>
                            <th style="text-align:center;">SL</th>
                            <th style="text-align:center;">Còn Lại</th>
                            <th style="text-align:center;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty books}">
                                <tr>
                                    <td colspan="10">
                                        <div class="empty-state">
                                            <div class="icon">📖</div>
                                            <p>Không tìm thấy sách nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="b" items="${books}" varStatus="st">
                                    <tr>
                                        <td style="color:#aaa;">${(currentPage - 1) * 10 + st.index + 1}</td>
                                        <td><code>${b.isbn}</code></td>
                                        <td><strong>${b.title}</strong></td>
                                        <td>${not empty b.authors ? b.authors : '—'}</td>
                                        <td><span class="badge-type">${b.categoryName}</span></td>
                                        <td>${b.publisherName}</td>
                                        <td>${b.publicationYear}</td>
                                        <td style="text-align:center;">${b.totalQuantity}</td>
                                        <td style="text-align:center;">
                                            <span class="${b.availableQuantity > 0 ? 'badge-avail' : 'badge-noavail'}">
                                                ${b.availableQuantity}
                                            </span>
                                        </td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="books?action=edit&isbn=${b.isbn}" class="btn-edit" title="Sửa">✏️</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete" title="Xóa"
                                               onclick="confirmDelete('${b.isbn}', '${b.title}'); return false;">🗑️</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                
                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px; margin-bottom:10px;">
                        <c:choose>
                            <c:when test="${not empty keyword}">
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/books?action=search&keyword=${keyword}&page=" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/books?action=list&page=" />
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${currentPage > 1}">
                            <a href="${pageUrl}${currentPage - 1}" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Trước</a>
                        </c:if>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageUrl}${i}" class="page-btn" style="padding:6px 12px; border:1px solid ${currentPage == i ? 'var(--primary)' : '#cbd5e1'}; border-radius:6px; text-decoration:none; color:${currentPage == i ? '#fff' : '#475569'}; background:${currentPage == i ? 'var(--primary)' : '#fff'}; font-weight:${currentPage == i ? 'bold' : 'normal'};">${i}</a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageUrl}${currentPage + 1}" class="page-btn" style="padding:6px 12px; border:1px solid #cbd5e1; border-radius:6px; text-decoration:none; color:#475569;">Sau</a>
                        </c:if>
                    </div>
                </c:if>

            </div>

    <!-- DELETE MODAL -->
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <h4>⚠️ Xác nhận xóa</h4>
            <p id="deleteModalText">Bạn có chắc muốn xóa sách này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(isbn, title) {
            document.getElementById('deleteModalText').textContent =
                'Xóa sách "' + title + '"? Hành động này sẽ xóa cả các bản sao liên quan!';
            document.getElementById('deleteConfirmLink').href = 'books?action=delete&isbn=' + isbn;
            document.getElementById('deleteModal').classList.add('show');
        }
        function closeModal() {
            document.getElementById('deleteModal').classList.remove('show');
        }
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });
    </script>
<jsp:include page="/includes/footer.jsp" />
