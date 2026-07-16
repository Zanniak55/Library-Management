<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Quản lý Thư viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', Arial, sans-serif;
            min-height: 100vh;
            background: linear-gradient(160deg, #0d1b3e 0%, #1a3a6e 50%, #0f2a5a 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* CARD */
        .card {
            background: #ffffff;
            border-radius: 16px;
            padding: 48px 40px 36px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        /* ICON */
        .card-icon {
            font-size: 44px;
            margin-bottom: 12px;
            display: block;
        }

        /* TITLE */
        .card-title {
            font-size: 26px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 6px;
        }

        .card-subtitle {
            font-size: 13px;
            color: #888;
            margin-bottom: 32px;
        }

        /* ERROR */
        .alert-error {
            background: #fff0f0;
            border: 1px solid #ffcccc;
            border-radius: 8px;
            padding: 10px 14px;
            margin-bottom: 20px;
            color: #cc0000;
            font-size: 13px;
            text-align: left;
        }

        /* FORM */
        .form-group {
            margin-bottom: 18px;
            text-align: left;
        }

        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #444;
            margin-bottom: 7px;
        }

        .form-input {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #e0e6f0;
            border-radius: 8px;
            font-size: 14px;
            color: #222;
            background: #f4f7fc;
            font-family: 'Inter', Arial, sans-serif;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input::placeholder { color: #aab; }
        .form-input:focus {
            border-color: #2e6ee1;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(46,110,225,0.1);
        }

        /* PASSWORD WRAP */
        .pw-wrap { position: relative; }
        .pw-toggle {
            position: absolute;
            right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none;
            cursor: pointer; color: #aab;
            font-size: 15px; padding: 2px;
            transition: color 0.2s;
        }
        .pw-toggle:hover { color: #555; }

        /* SUBMIT */
        .btn-submit {
            width: 100%;
            padding: 13px;
            background: #2e6ee1;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            font-family: 'Inter', Arial, sans-serif;
            cursor: pointer;
            margin-top: 6px;
            transition: background 0.2s, transform 0.1s;
            letter-spacing: 0.2px;
        }
        .btn-submit:hover { background: #1d5cc4; }
        .btn-submit:active { transform: scale(0.98); }

        /* READER LINK */
        .reader-link {
            display: block;
            margin-top: 20px;
            font-size: 13px;
            color: #2e6ee1;
            text-decoration: none;
        }
        .reader-link:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="card">
    <span class="card-icon">📘</span>
    <div class="card-title">Thư viện</div>
    <div class="card-subtitle">Đăng nhập để quản lý hệ thống</div>

    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
    <div class="alert-error">⚠ <%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">

        <div class="form-group">
            <label class="form-label" for="email">Email</label>
            <input type="text"
                   id="email"
                   name="email"
                   class="form-input"
                   placeholder="admin@library.com"
                   autocomplete="username"
                   required>
        </div>

        <div class="form-group">
            <label class="form-label" for="password">Mật khẩu</label>
            <div class="pw-wrap">
                <input type="password"
                       id="password"
                       name="password"
                       class="form-input"
                       placeholder="••••••••"
                       autocomplete="current-password"
                       required>
                <button type="button" class="pw-toggle" id="togglePwd">👁</button>
            </div>
        </div>

        <button type="submit" class="btn-submit">↩ Đăng nhập</button>
    </form>

    <a href="${pageContext.request.contextPath}/reader-login" class="reader-link">
        Đăng nhập dành cho độc giả
    </a>
</div>

<script>
    document.getElementById('togglePwd').addEventListener('click', function () {
        const inp = document.getElementById('password');
        const isHidden = inp.type === 'password';
        inp.type = isHidden ? 'text' : 'password';
        this.textContent = isHidden ? '🙈' : '👁';
    });
    document.getElementById('email').focus();
</script>

</body>
</html>
