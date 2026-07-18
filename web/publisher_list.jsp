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
    request.setAttribute("pageTitle", "Quản lý NXB - Thư viện");
    request.setAttribute("activePage", "publishers");
%>
<jsp:include page="/includes/header.jsp" />

            <!-- ALERTS -->
            <c:if test="${not empty successMsg}">
                <div class="alert alert-success">✅ ${successMsg}</div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger">⚠️ ${errorMsg}</div>
            </c:if>

            <!-- TOOLBAR -->
            <div class="toolbar">
                <div class="toolbar-left">
                    <form method="get" action="<%= ctx %>/publishers" class="search-group">
                        <input type="hidden" name="action" value="list">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Tìm tên, địa chỉ, số điện thoại..."
                               value="${not empty keyword ? keyword : ''}">
                        <button type="submit" class="search-btn">🔍 Tìm</button>
                    </form>
                    <c:if test="${not empty keyword}">
                        <a href="<%= ctx %>/publishers" style="font-size:13px;color:var(--primary);text-decoration:none;">✕ Xóa lọc</a>
                    </c:if>
                </div>
                <a href="<%= ctx %>/publishers?action=add" class="btn-add">➕ Thêm NXB</a>
            </div>

            <!-- TABLE CARD -->
            <div class="table-card">
                <div class="table-card-header">
                    <div class="table-card-header-left">
                        <h3>🏢 Danh sách nhà xuất bản</h3>
                        <c:if test="${not empty publishers}">
                            <span class="count-badge">${publishers.size()} NXB</span>
                        </c:if>
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã NXB</th>
                            <th>Tên NXB</th>
                            <th>Địa chỉ</th>
                            <th>SĐT</th>
                            <th>Email</th>
                            <th style="text-align:center;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty publishers}">
                                <c:forEach var="p" items="${publishers}" varStatus="loop">
                                    <tr>
                                        <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                                        <td>${p.publisherID}</td>
                                        <td>${p.publisherName}</td>
                                        <td>${p.address}</td>
                                        <td>${p.phone}</td>
                                        <td>${p.email}</td>
                                        <td style="text-align:center;white-space:nowrap;">
                                            <a href="<%= ctx %>/publishers?action=edit&id=${p.publisherID}" class="btn-edit" title="Sửa">✏️</a>
                                            &nbsp;
                                            <a href="#" class="btn-delete" title="Xóa"
                                               onclick="confirmDelete(${p.publisherID}, '${p.publisherName}'); return false;">🗑️</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <div class="icon">🏢</div>
                                            <p>Không tìm thấy nhà xuất bản nào.</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
                
                <c:if test="${totalPages > 1}">
                    <div class="pagination" style="display:flex; justify-content:center; gap:8px; margin-top:20px; margin-bottom:10px;">
                        <c:choose>
                            <c:when test="${not empty keyword}">
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/publishers?action=list&keyword=${keyword}&page=" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="pageUrl" value="${pageContext.request.contextPath}/publishers?action=list&page=" />
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
            <p id="deleteModalText">Bạn có chắc muốn xóa nhà xuất bản này?</p>
            <div class="modal-actions">
                <button class="btn-cancel-modal" onclick="closeModal()">Hủy</button>
                <a id="deleteConfirmLink" href="#" class="btn-confirm-delete">🗑️ Xóa</a>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            document.getElementById('deleteModalText').textContent =
                'Xóa nhà xuất bản "' + name + '"? Hành động này có thể ảnh hưởng tới các sách thuộc nhà xuất bản này!';
            document.getElementById('deleteConfirmLink').href = '<%= ctx %>/publishers?action=delete&id=' + id;
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
