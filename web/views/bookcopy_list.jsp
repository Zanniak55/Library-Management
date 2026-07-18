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
    request.setAttribute("pageTitle", "Quản lý Bản sao sách - Thư viện");
    request.setAttribute("activePage", "bookcopies");
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
                    <form action="bookcopies" method="get" class="search-group">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm tên, barcode, vị trí…"
                               value="${not empty keyword ? keyword : ''}">
                        <button class="search-btn" type="submit">🔍 Tìm</button>
                    </form>
                    <c:if test="${not empty keyword}">
                        <a href="bookcopies" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa</a>
                    </c:if>
                    <span style="color:#ddd;">|</span>
                    <form action="bookcopies" method="get" class="search-group">
                        <input type="hidden" name="action" value="filter">
                        <select name="isbn" class="select-input">
                            <option value="">-- Lọc theo sách --</option>
                            <c:forEach var="b" items="${books}">
                                <option value="${b[0]}" ${filterISBN == b[0] ? 'selected' : ''}>${b[1]}</option>
                            </c:forEach>
                        </select>
                        <button class="search-btn" type="submit">🏷️ Lọc</button>
                    </form>
                    <c:if test="${not empty filterISBN}">
                        <a href="bookcopies" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa lọc</a>
                    </c:if>
                </div>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>📦 Danh sách Bản Sao</h3>
                        <span class="count-badge">
                            ${copies.size()} bản
                        </span>
                    </div>
                    <div>
                        <a href="bookcopies?action=new" class="btn-add">➕ Thêm Bản Sao</a>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Barcode</th>
                            <th>Tên Sách</th>
                            <th style="text-align:center;">Bản Số</th>
                            <th style="text-align:center;">Tình Trạng</th>
                            <th style="text-align:center;">Trạng Thái</th>
                            <th>Vị Trí Kệ</th>
                            <th style="text-align:center;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty copies}">
                                <tr>
                                    <td colspan="8">
                                        <div class="empty-state">
                                            <div class="icon">📦</div>
                                            <p>Không tìm thấy bản sao nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${copies}" varStatus="st">
                                    <tr>
                                        <td style="color:#aaa;">${(currentPage - 1) * 10 + st.index + 1}</td>
                                        <td><code>${c.barcode}</code></td>
                                        <td><strong>${c.bookTitle}</strong></td>
                                        <td style="text-align:center;">${c.copyNumber}</td>
                                        <td style="text-align:center;">
                                            <span class="${c.condition == 'Mới' ? 'badge-new' : c.condition == 'Hỏng' ? 'badge-damaged' : 'badge-old'}">
                                                ${c.condition}
                                            </span>
                                        </td>
                                        <td style="text-align:center;">
                                            <span class="${c.status == 'Trên kệ' ? 'badge-shelf' : c.status == 'Bảo trì' ? 'badge-maintain' : 'badge-borrowed'}">
                                                ${c.status}
                                            </span>
                                        </td>
                                        <td>${not empty c.shelfLocation ? c.shelfLocation : '—'}</td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="bookcopies?action=edit&id=${c.copyID}" class="btn-edit" title="Sửa">✏️</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete" title="Xóa"
                                               onclick="confirmDelete(${c.copyID}, '${c.barcode}'); return false;">🗑️</a>
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
                            <c:when test="${not empty filterISBN}">
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/bookcopies?action=filter&isbn=${filterISBN}&page=" />
                            </c:when>
                            <c:when test="${not empty keyword}">
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/bookcopies?action=search&keyword=${keyword}&page=" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/bookcopies?action=list&page=" />
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
            <p id="deleteModalText">Bạn có chắc muốn xóa bản sao này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, barcode) {
            document.getElementById('deleteModalText').textContent =
                'Xóa bản sao "' + barcode + '"?';
            document.getElementById('deleteConfirmLink').href = 'bookcopies?action=delete&id=' + id;
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
