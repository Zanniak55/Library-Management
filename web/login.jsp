<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng nhập - Thư viện</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #e8e8e0; display: flex; justify-content: center; align-items: center; min-height: 100vh; }

        .container {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            width: 860px;
            min-height: 520px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.10);
        }

        /* LEFT - FORM */
        .left {
            flex: 1;
            padding: 52px 52px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .brand { font-size: 20px; font-weight: bold; margin-bottom: 40px; color: #222; }
        .brand span { color: #c0392b; }
        h2 { font-size: 32px; font-weight: bold; color: #1a1a1a; margin-bottom: 28px; }

        label { display: block; font-size: 13px; font-weight: bold; color: #333; margin-bottom: 6px; }
        input[type=text], input[type=password] {
            width: 100%; padding: 12px 14px; border: 1.5px solid #e0e0e0;
            border-radius: 8px; font-size: 14px; background: #f7f7f5; color: #222;
            margin-bottom: 16px; transition: border 0.2s;
        }
        input[type=text]:focus, input[type=password]:focus {
            outline: none; border-color: #2c3e50; background: white;
        }
        button[type=submit] {
            width: 100%; padding: 13px; background: #2c3e50; color: white;
            border: none; border-radius: 8px; font-size: 15px; font-weight: bold;
            cursor: pointer; margin-top: 4px; transition: background 0.2s;
        }
        button[type=submit]:hover { background: #1a252f; }

        .err { background: #fdecea; color: #c0392b; padding: 10px 14px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; }

        /* RIGHT - ILLUSTRATION */
        .right {
            width: 380px;
            background: #f0ede6;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px;
        }
        .right svg { width: 100%; max-width: 320px; }
    </style>
</head>
<body>
<div class="container">

    <!-- FORM -->
    <div class="left">
        <div class="brand">📚 Thư<span>Viện</span></div>
        <h2>Đăng nhập</h2>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
        <div class="err">⚠ <%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <label>Email</label>
            <input type="text" name="email" placeholder="Nhập email của bạn" required>

            <label>Mật khẩu</label>
            <input type="password" name="password" placeholder="Nhập mật khẩu" required>

            <button type="submit">Đăng nhập</button>
        </form>
    </div>

    <!-- ILLUSTRATION -->
    <div class="right">
        <svg viewBox="0 0 320 340" xmlns="http://www.w3.org/2000/svg">
            <!-- Shadow -->
            <ellipse cx="160" cy="310" rx="90" ry="12" fill="#d4c9b0" opacity="0.5"/>

            <!-- Book 1 - bottom red -->
            <rect x="60" y="255" width="200" height="36" rx="4" fill="#e05a5a"/>
            <rect x="60" y="255" width="18" height="36" rx="2" fill="#c04040"/>
            <rect x="64" y="260" width="10" height="26" rx="1" fill="#d04848"/>

            <!-- Book 2 - yellow -->
            <rect x="70" y="220" width="185" height="36" rx="4" fill="#f0b429"/>
            <rect x="70" y="220" width="18" height="36" rx="2" fill="#d49a10"/>
            <rect x="74" y="225" width="10" height="26" rx="1" fill="#e0aa20"/>

            <!-- Book 3 - teal -->
            <rect x="65" y="183" width="190" height="38" rx="4" fill="#2a9d8f"/>
            <rect x="65" y="183" width="18" height="38" rx="2" fill="#1f7a6e"/>
            <rect x="69" y="188" width="10" height="28" rx="1" fill="#259080"/>
            <!-- Bookmark ribbon -->
            <polygon points="210,183 222,183 222,210 216,205 210,210" fill="#e05a5a"/>

            <!-- Book 4 - dark blue -->
            <rect x="75" y="148" width="175" height="36" rx="4" fill="#264653"/>
            <rect x="75" y="148" width="18" height="36" rx="2" fill="#1a3340"/>
            <rect x="79" y="153" width="10" height="26" rx="1" fill="#1f3d4a"/>
            <!-- Diamond pattern -->
            <rect x="110" y="158" width="100" height="16" rx="2" fill="none" stroke="#3a6278" stroke-width="1.5"/>
            <line x1="135" y1="158" x2="135" y2="174" stroke="#3a6278" stroke-width="1"/>
            <line x1="160" y1="158" x2="160" y2="174" stroke="#3a6278" stroke-width="1"/>
            <line x1="185" y1="158" x2="185" y2="174" stroke="#3a6278" stroke-width="1"/>

            <!-- Book 5 - orange top -->
            <rect x="80" y="115" width="160" height="34" rx="4" fill="#e07b39"/>
            <rect x="80" y="115" width="18" height="34" rx="2" fill="#c06020"/>
            <rect x="84" y="120" width="10" height="24" rx="1" fill="#d07030"/>
            <!-- Star on orange book -->
            <polygon points="160,121 163,130 172,130 165,136 168,145 160,139 152,145 155,136 148,130 157,130" fill="#f5d020" opacity="0.9"/>

            <!-- Pen -->
            <rect x="195" y="268" width="6" height="55" rx="3" transform="rotate(-20,195,268)" fill="#2c3e50"/>
            <polygon points="195,320 201,320 198,335" transform="rotate(-20,195,268)" fill="#f0b429"/>

            <!-- Plant pot -->
            <rect x="240" y="278" width="32" height="24" rx="4" fill="#e07b39"/>
            <rect x="235" y="274" width="42" height="8" rx="4" fill="#c06020"/>
            <!-- Plant leaves -->
            <ellipse cx="256" cy="258" rx="10" ry="20" fill="#2a9d8f" transform="rotate(-15,256,258)"/>
            <ellipse cx="256" cy="255" rx="10" ry="20" fill="#27ae60" transform="rotate(10,256,255)"/>
            <ellipse cx="256" cy="260" rx="6" ry="14" fill="#2ecc71" transform="rotate(-5,256,260)"/>

            <!-- Sparkles -->
            <circle cx="55" cy="140" r="4" fill="#4a90d9" opacity="0.8"/>
            <circle cx="270" cy="130" r="6" fill="#4a90d9" opacity="0.6"/>
            <circle cx="290" cy="200" r="4" fill="#4a90d9" opacity="0.7"/>
            <circle cx="45" cy="210" r="5" fill="#4a90d9" opacity="0.5"/>

            <!-- 4-point stars -->
            <path d="M55,140 L57,134 L59,140 L65,140 L59,144 L61,152 L55,147 L49,152 L51,144 L45,140 Z" fill="#4a90d9" opacity="0.7" transform="scale(0.5) translate(55,140)"/>
            <path d="M270,120 L273,112 L276,120 L284,120 L276,126 L279,136 L270,130 L261,136 L264,126 L256,120 Z" fill="#4a90d9" opacity="0.6" transform="scale(0.55) translate(220,105)"/>
        </svg>
    </div>

</div>
</body>
</html>
