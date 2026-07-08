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
                max-width: 700px;
                margin: 2rem auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 4px 20px rgba(0,0,0,.09);
                overflow: hidden;
            }
            .form-header {
                background: linear-gradient(135deg, #1e3c72, #2a5298);
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
                    <i class="bi bi-${empty book ? 'plus-circle' : 'pencil-square'} me-2"></i>
                    ${formTitle}
                </h4>
            </div>
            <div class="form-body">
                <form action="books" method="post" id="bookForm" novalidate>

                    <%-- actionType: phân biệt thêm / sửa --%>
                    <input type="hidden" name="actionType" value="${empty book ? 'add' : 'edit'}">

                    <%-- ── Thông tin cơ bản ── --%>
                    <p class="section-label">Thông Tin Cơ Bản</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">ISBN</label>
                            <c:choose>
                                <c:when test="${not empty book}">
                                    <%-- Khi edit: hiển thị ISBN, readonly --%>
                                    <input type="text" name="isbn" class="form-control"
                                           value="${book.isbn}" readonly>
                                </c:when>
                                <c:otherwise>
                                    <%-- Khi thêm mới: auto-generate, người dùng vẫn có thể sửa --%>
                                    <div class="input-group">
                                        <input type="text" name="isbn" id="isbnField"
                                               class="form-control" required maxlength="20"
                                               placeholder="978-xxx-xxx-xxx-x">
                                        <button type="button" class="btn btn-outline-secondary"
                                                onclick="generateISBN()" title="Tạo ISBN mới">
                                            <i class="bi bi-arrow-clockwise"></i>
                                        </button>
                                    </div>
                                    <small class="text-muted">Tự động tạo, hoặc nhấn 🔄 để tạo lại.</small>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Năm Xuất Bản</label>
                            <input type="number" name="publicationYear" class="form-control"
                                   min="1000" max="2099" placeholder="VD: 2023"
                                   value="${not empty book ? book.publicationYear : ''}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Tên Sách <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" required maxlength="300"
                               placeholder="Nhập tên sách…"
                               value="${not empty book ? book.title : ''}">
                        <div class="invalid-feedback">Vui lòng nhập tên sách.</div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Ngôn Ngữ</label>
                        <select name="language" class="form-select">
                            <c:set var="lang" value="${not empty book ? book.language : 'Tiếng Việt'}"/>
                            <option value="Tiếng Việt" ${lang == 'Tiếng Việt' ? 'selected' : ''}>Tiếng Việt</option>
                            <option value="Tiếng Anh"  ${lang == 'Tiếng Anh'  ? 'selected' : ''}>Tiếng Anh</option>
                            <option value="Tiếng Nhật" ${lang == 'Tiếng Nhật' ? 'selected' : ''}>Tiếng Nhật</option>
                            <option value="Tiếng Pháp" ${lang == 'Tiếng Pháp' ? 'selected' : ''}>Tiếng Pháp</option>
                            <option value="Khác"       ${lang == 'Khác'       ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>

                    <%-- ── Phân loại ── --%>
                    <p class="section-label mt-4">Phân Loại & Nhà Xuất Bản</p>

                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Thể Loại</label>
                            <select name="categoryID" class="form-select">
                                <option value="">-- Chọn thể loại --</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat[0]}"
                                            ${not empty book && book.categoryID == cat[0] ? 'selected' : ''}>
                                        ${cat[1]}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Nhà Xuất Bản</label>
                            <select name="publisherID" class="form-select">
                                <option value="">-- Chọn NXB --</option>
                                <c:forEach var="pub" items="${publishers}">
                                    <option value="${pub[0]}"
                                            ${not empty book && book.publisherID == pub[0] ? 'selected' : ''}>
                                        ${pub[1]}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <%-- ── Số lượng ── --%>
                    <div class="mb-3">
                        <label class="form-label">Tác Giả</label>
                        <input type="text" name="authorName" class="form-control"
                               placeholder="Nhập tên tác giả…"
                               value="${not empty book ? book.authors : ''}">
                        <small class="text-muted">Nhập tên tác giả, nhiều tác giả cách nhau bằng dấu phẩy.</small>
                    </div>

                    <p class="section-label mt-4">Số Lượng</p>

                    <div class="row g-3 mb-4">
                        <div class="col-md-6">
                            <label class="form-label">Tổng Số Lượng <span class="text-danger">*</span></label>
                            <input type="number" name="totalQuantity" id="totalQty"
                                   class="form-control" min="0" required placeholder="0"
                                   value="${not empty book ? book.totalQuantity : ''}">
                            <div class="invalid-feedback">Vui lòng nhập số lượng.</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số Lượng Còn Lại</label>
                            <input type="number" name="availableQuantity" id="availQty"
                                   class="form-control" min="0" placeholder="0"
                                   value="${not empty book ? book.availableQuantity : ''}">
                            <small class="text-muted">Không được vượt quá Tổng số lượng.</small>
                        </div>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="bi bi-floppy-fill me-2"></i>
                            ${empty book ? 'Thêm Sách' : 'Lưu Thay Đổi'}
                        </button>
                        <a href="books" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-arrow-left me-1"></i>Quay Lại
                        </a>
                    </div>
                </form>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                    // ── Auto-generate ISBN với prefix 978- ──────────────────────────────────
                                                    function generateISBN() {
                                                        let digits = '978';
                                                        for (let i = 0; i < 9; i++) {
                                                            digits += Math.floor(Math.random() * 10);
                                                        }
                                                        // Tính check digit
                                                        let sum = 0;
                                                        for (let i = 0; i < 12; i++) {
                                                            sum += parseInt(digits[i]) * (i % 2 === 0 ? 1 : 3);
                                                        }
                                                        const check = (10 - (sum % 10)) % 10;
                                                        const full = digits + check;
                                                        // Format 978-XXX-XXXXX-X
                                                        document.getElementById('isbnField').value =
                                                                full.slice(0, 3) + '-' + full.slice(3, 6) + '-' + full.slice(6, 12) + '-' + full.slice(12);
                                                    }
                                                    window.onload = function () {
                                                        const f = document.getElementById('isbnField');
                                                        if (f)
                                                            generateISBN();
                                                    };

                                                    // ── Validation ──────────────────────────────────────────────────────────
                                                    document.getElementById('bookForm').addEventListener('submit', function (e) {
                                                        if (!this.checkValidity()) {
                                                            e.preventDefault();
                                                            e.stopPropagation();
                                                        }
                                                        this.classList.add('was-validated');
                                                    });

                                                    // availableQty không được vượt totalQty
                                                    document.getElementById('totalQty').addEventListener('input', function () {
                                                        const avail = document.getElementById('availQty');
                                                        if (parseInt(avail.value) > parseInt(this.value))
                                                            avail.value = this.value;
                                                    });
        </script>
    </body>
</html>
