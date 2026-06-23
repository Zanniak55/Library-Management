<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập - Thư viện</title>
        <style>
            body { font-family: Arial, sans-serif; background: #f5f5f5; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .box { background: white; padding: 36px; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.12); width: 320px; }
            h2 { margin-bottom: 20px; text-align: center; }
            label { display: block; margin-bottom: 4px; font-size: 14px; }
            input { width: 100%; padding: 9px; border: 1px solid #ccc; border-radius: 4px; margin-bottom: 14px; font-size: 14px; }
            button { width: 100%; padding: 10px; background: #2c3e50; color: white; border: none; border-radius: 4px; font-size: 15px; cursor: pointer; }
            button:hover { background: #1a252f; }
            .err { color: red; font-size: 13px; margin-bottom: 12px; }
        </style>
    </head>
    <body>
        <div class="box">
            <h2>Đăng nhập</h2>

            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="err"><%= error %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <label>Email</label>
                <input type="text" name="email" required>

                <label>Mật khẩu</label>
                <input type="password" name="password" required>

                <button type="submit">Đăng nhập</button>
            </form>
        </div>
    </body>
</html>
