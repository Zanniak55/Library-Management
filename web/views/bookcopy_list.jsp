<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Bản Sao Sách</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <style>
            body {
                background: #f5f7fa;
            }
            .page-header {
                background: linear-gradient(135deg, #b45309, #d97706);
                color: white;
                padding: 1.5rem 2rem;
                border-radius: 12px;
                margin-bottom: 1.5rem;
            }
            .page-header a {
                text-decoration: none;
                color: white;
            }
            .table-card {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 2px 12px rgba(0,0,0,.08);
            }
            .table thead {
                background: #b45309;
                color: #fff;
            }
            .badge-shelf    {
                background: #d1fae5;
                color: #065f46;
            }
            .badge-borrowed {
                background: #fee2e2;
                color: #991b1b;
            }
            .badge-maintain {
                background: #fef3c7;
                color: #92400e;
            }
            .badge-new  {
                background: #dbeafe;
                color: #1e40af;
            }
            .badge-old  {
                background: #f3f4f6;
                color: #374151;
            }
            .badge-damaged {
                background: #fee2e2;
                color: #991b1b;
            }
        </style>
    </head>
    <body>
        <div class="container py-4">

            <div class="page-header d-flex justify-content-between align-items-center">
                <div>
                    <a href="${pageContext.request.contextPath}/dashboard">
                        <h2 class="mb-0"><i class="bi bi-collection-fill me-2"></i>Bản Sao Sách</h2>
                    </a>
                    <small class="opacity-75">Quản lý bản sao vật lý</small>
                </div>
                <a href="bookcopies?action=new" class="btn btn-warning fw-semibold">
                    <i class="bi bi-plus-lg me-1"></i>Thêm Bản Sao
                </a>
            </div>

            <%-- Thông báo --%>
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle-fill me-2"></i>${sessionScope.success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-circle-fill me-2"></i>${sessionScope.error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <%-- Tìm kiếm + Lọc theo sách --%>
            <div class="row g-2 mb-3">
                <div class="col-md-6">
                    <form action="bookcopies" method="get" class="d-flex gap-2">
                        <input type="hidden" name="action" value="search">
                        <input type="text" name="keyword" class="form-control"
                               placeholder="Tìm theo tên sách, barcode, vị trí…"
                               value="${not empty keyword ? keyword : ''}">
                        <button class="btn btn-warning px-3"><i class="bi bi-search"></i></button>
                            <c:if test="${not empty keyword}">
                            <a href="bookcopies" class="btn btn-outline-secondary">Xóa</a>
                        </c:if>
                    </form>
                </div>
                <div class="col-md-6">
                    <form action="bookcopies" method="get" class="d-flex gap-2">
                        <input type="hidden" name="action" value="filter">
                        <select name="isbn" class="form-select">
                            <option value="">-- Lọc theo sách --</option>
                            <c:forEach var="b" items="${books}">
                                <option value="${b[0]}" ${filterISBN == b[0] ? 'selected' : ''}>${b[1]}</option>
                            </c:forEach>
                        </select>
                        <button class="btn btn-outline-warning px-3"><i class="bi bi-funnel-fill"></i></button>
                            <c:if test="${not empty filterISBN}">
                            <a href="bookcopies" class="btn btn-outline-secondary">Xóa</a>
                        </c:if>
                    </form>
                </div>
            </div>

            <%-- Bảng danh sách --%>
            <div class="table-card">
                <table class="table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Barcode</th>
                            <th>Tên Sách</th>
                            <th class="text-center">Bản Số</th>
                            <th class="text-center">Tình Trạng</th>
                            <th class="text-center">Trạng Thái</th>
                            <th>Vị Trí Kệ</th>
                            <th class="text-center">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty copies}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-3 d-block mb-2"></i>
                                        Không có bản sao nào.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="c" items="${copies}" varStatus="st">
                                    <tr>
                                        <td class="text-muted">${st.index + 1}</td>
                                        <td><code>${c.barcode}</code></td>
                                        <td class="fw-semibold">${c.bookTitle}</td>
                                        <td class="text-center">${c.copyNumber}</td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill px-3
                                                  ${c.condition == 'Mới' ? 'badge-new' : c.condition == 'Hỏng' ? 'badge-damaged' : 'badge-old'}">
                                                ${c.condition}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge rounded-pill px-3
                                                  ${c.status == 'Trên kệ' ? 'badge-shelf' : c.status == 'Bảo trì' ? 'badge-maintain' : 'badge-borrowed'}">
                                                <i class="bi bi-${c.status == 'Trên kệ' ? 'check-circle-fill' : c.status == 'Bảo trì' ? 'tools' : 'arrow-left-right'} me-1"></i>
                                                ${c.status}
                                            </span>
                                        </td>
                                        <td>${not empty c.shelfLocation ? c.shelfLocation : '—'}</td>
                                        <td class="text-center" style="white-space:nowrap">
                                            <a href="bookcopies?action=edit&id=${c.copyID}"
                                               class="btn btn-sm btn-outline-primary me-1" title="Sửa">
                                                <i class="bi bi-pencil-fill"></i>
                                            </a>
                                            <a href="bookcopies?action=delete&id=${c.copyID}"
                                               class="btn btn-sm btn-outline-danger" title="Xóa"
                                               onclick="return confirm('Xóa bản sao ${c.barcode}?')">
                                                <i class="bi bi-trash-fill"></i>
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
            <p class="text-muted mt-2 small">Tổng cộng: <strong>${copies.size()}</strong> bản sao</p>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
