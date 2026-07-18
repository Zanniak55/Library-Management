<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập Độc giả - Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            width: 100%;
            max-width: 400px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(245, 158, 11, 0.2);
            padding: 40px;
            text-align: center;
        }
        .logo {
            font-size: 48px;
            margin-bottom: 16px;
        }
        .title {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
        }
        .subtitle {
            color: #64748b;
            font-size: 14px;
            margin-bottom: 32px;
        }
        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #475569;
            margin-bottom: 8px;
        }
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .form-control:focus {
            outline: none;
            border-color: #f59e0b;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2);
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background: #f59e0b;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 10px;
        }
        .btn-login:hover {
            background: #d97706;
        }
        .error-msg {
            background: #fee2e2;
            color: #ef4444;
            padding: 12px;
            border-radius: 8px;
            font-size: 14px;
            margin-bottom: 20px;
            text-align: left;
            border-left: 4px solid #ef4444;
        }
        .staff-link {
            display: block;
            margin-top: 24px;
            color: #f59e0b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        .staff-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="logo">📚</div>
        <h1 class="title">Thư viện</h1>
        <div class="subtitle">Đăng nhập dành cho Độc giả</div>
        
        <c:if test="${not empty error}">
            <div class="error-msg">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/user-login" method="POST">
            <div class="form-group">
                <label>Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" required placeholder="Nhập username...">
            </div>
            
            <div class="form-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" class="form-control" required placeholder="Nhập mật khẩu...">
            </div>
            
            <button type="submit" class="btn-login">Đăng nhập</button>
        </form>
        
        <a href="${pageContext.request.contextPath}/login" class="staff-link">Quản trị viên / Thủ thư đăng nhập</a>
    </div>
</body>
</html>
