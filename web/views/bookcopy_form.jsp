<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>${formTitle}</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
        <style>
            body {
                background: #f5f7fa;
            }
            .form-card {
                max-width: 640px;
                margin: 2rem auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,.09);
                overflow: hidden;
            }
            .form-header {
                background: linear-gradient(135deg, #b45309, #d97706);
                color: white;
                padding: 1.4rem 2rem;
            }
            .form-body {
                padding: 2rem;
            }
            .form-label {
                font-weight: 600;
                font-size: .9rem;
                color: #374151;
            }
            .section-label {
                font-size: .75rem;
                text-transform: uppercase;
                letter-spacing: .08em;
                color: #9ca3af;
                border-bottom: 1px solid #e5e7eb;
                padding-bottom: .3rem;
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="form-card">
            <div class="form-header">
                <h4 class="mb-0">
                    <i class="bi bi-${empty copy ? 'plus-circle' : 'pencil-square'} me-2"></i>
                    ${formTitle}
                </h4>
            </div>
            <div class="form-body">

                <%-- Thông báo lỗi --%>
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-circle-fill me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <form action="bookcopies" method="post" id="copyForm" novalidate>
                    <input type="hidden" name="actionType" value="${empty copy ? 'add' : 'edit'}">
                    <c:if test="${not empty copy}">
                        <input type="hidden" name="copyID" value="${copy.copyID}">
                    </c:if>

                    <p class="section-label">Thông Tin Bản Sao</p>

                    <%-- Chọn sách (chỉ hiện khi thêm mới) --%>
                    <c:choose>
                        <c:when test="${not empty copy}">
                            <div class="mb-3">
                                <label class="form-label">Sách</label>
                                <input type="text" class="form-control" value="${copy.bookTitle}" readonly>
                                <input type="hidden" name="isbn" value="${copy.isbn}">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="mb-3">
                                <label class="form-label">Sách <span class="text-danger">*</span></label>
                                <select name="isbn" class="form-select" required>
                                    <option value="">-- Chọn sách --</option>
                                    <c:forEach var="b" items="${books}">
                                        <option value="${b[0]}">${b[1]}</option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">Vui lòng chọn sách.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <div class="mb-3">
                        <label class="form-label">Barcode <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <input type="text" name="barcode" id="barcodeField"
                                   class="form-control" required maxlength="50"
                                   placeholder="BC-XXX"
                                   value="${not empty copy ? copy.barcode : ''}"
                                   ${not empty copy ? 'readonly' : ''}>
                            <c:if test="${empty copy}">
                                <button type="button" class="btn btn-outline-secondary"
                                        onclick="generateBarcode()" title="Tạo barcode tự động">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </button>
                            </c:if>
                        </div>
                        <div class="invalid-feedback">Vui lòng nhập barcode.</div>
                    </div>

                    <p class="section-label mt-4">Tình Trạng & Vị Trí</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Tình Trạng</label>
                            <select name="condition" class="form-select">
                                <c:set var="cond" value="${not empty copy ? copy.condition : 'Mới'}"/>
                                <option value="Mới"   ${cond == 'Mới'   ? 'selected' : ''}>Mới</option>
                                <option value="Cũ"    ${cond == 'Cũ'    ? 'selected' : ''}>Cũ</option>
                                <option value="Hỏng"  ${cond == 'Hỏng'  ? 'selected' : ''}>Hỏng</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Trạng Thái</label>
                            <select name="status" class="form-select">
                                <c:set var="st" value="${not empty copy ? copy.status : 'Trên kệ'}"/>
                                <option value="Trên kệ"      ${st == 'Trên kệ'      ? 'selected' : ''}>Trên kệ</option>
                                <option value="Đã cho mượn"  ${st == 'Đã cho mượn'  ? 'selected' : ''}>Đã cho mượn</option>
                                <option value="Bảo trì"      ${st == 'Bảo trì'      ? 'selected' : ''}>Bảo trì</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Vị Trí Kệ</label>
                        <input type="text" name="shelfLocation" class="form-control"
                               placeholder="VD: A1-01"
                               value="${not empty copy ? copy.shelfLocation : ''}">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-warning px-4 fw-semibold">
                            <i class="bi bi-floppy-fill me-2"></i>
                            ${empty copy ? 'Thêm Bản Sao' : 'Lưu Thay Đổi'}
                        </button>
                        <a href="bookcopies" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i>Quay Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                            function generateBarcode() {
                                                const num = String(Math.floor(Math.random() * 900) + 100).padStart(3, '0');
                                                const ts = Date.now().toString().slice(-4);
                                                document.getElementById('barcodeField').value = 'BC-' + num + ts;
                                            }
                                            window.onload = function () {
                                                const f = document.getElementById('barcodeField');
                                                if (f && !f.readOnly && !f.value)
                                                    generateBarcode();
                                            };
                                            document.getElementById('copyForm').addEventListener('submit', function (e) {
                                                if (!this.checkValidity()) {
                                                    e.preventDefault();
                                                    e.stopPropagation();
                                                }
                                                this.classList.add('was-validated');
                                            });
        </script>
    </body>
</html>
