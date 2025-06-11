<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>CodingBat - Authorization</title>
    <link rel="icon" type="image/x-icon" href="assets/img/logo.png">
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/toast.css">
    <link rel="stylesheet" href="assets/css/auth.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-page">
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
            <form id="login-form" action="${pageContext.request.contextPath}/auth/signin" method="POST"
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

            <form id="signup-form" action="${pageContext.request.contextPath}/auth/signup" method="POST"
                  class="auth-form">
                <div class="form-group">
                    <label for="signup-name">Full name</label>
                    <input name="name" type="text" id="signup-name" required>
                </div>
                <div class="form-group">
                    <label for="signup-email">Email</label>
                    <input name="email" type="text" id="signup-email" required>
                </div>
                <div class="form-group">
                    <label for="signup-password">Password</label>
                    <input name="password" type="password" id="signup-password" required>
                </div>
                <button type="submit" class="btn btn-primary">Sign Up</button>
                <p class="error-message" id="signup-error"></p>
            </form>
        </div>
    </div>
</div>

<script src="assets/js/theme.js"></script>
<script src="assets/js/auth.js"></script>
<script src="assets/js/toast.js"></script>
</body>
</html>
