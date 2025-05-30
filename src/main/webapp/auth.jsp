<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>CodingBat</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-container">
    <div class="theme-toggle">
        <i class="fas fa-moon"></i>
    </div>
    <div class="auth-container">

        <div class="auth-logo">
            <img id="logo-img" src="assets/img/logo-black.png" width="200px" alt="404">
        </div>

        <div class="auth-tabs">
            <button class="auth-tab active" data-tab="login">Sign In</button>
            <button class="auth-tab" data-tab="signup">Sign Up</button>
        </div>

        <div class="auth-form-container">
            <form id="login-form" action="${pageContext.request.contextPath}/auth/signin" method="post"
                  class="auth-form active">
                <div class="form-group">
                    <label for="login-username">Email</label>
                    <input name="email" type="text" id="login-username" required>
                </div>
                <div class="form-group">
                    <label for="login-password">Password</label>
                    <input name="password" type="password" id="login-password" required>
                </div>
                <button type="submit" class="btn btn-primary">Sign In</button>
                <p class="error-message" id="login-error"></p>
            </form>

            <form id="signup-form" action="${pageContext.request.contextPath}/auth/signup" method="post"
                  class="auth-form">
                <div class="form-group">
                    <label for="signup-username">Email</label>
                    <input name="email" type="text" id="signup-username" required>
                </div>
                <div class="form-group">
                    <label for="signup-password">Password</label>
                    <input name="password" type="password" id="signup-password" required>
                </div>
                <div class="form-group">
                    <label for="signup-confirm">Confirm Password</label>
                    <input type="password" id="signup-confirm" required>
                </div>
                <button type="submit" class="btn btn-primary">Sign Up</button>
                <p class="error-message" id="signup-error"></p>
            </form>
        </div>
    </div>
</div>


<script src="assets/js/theme.js"></script>
<script src="assets/js/auth.js"></script>
</body>
</html>
