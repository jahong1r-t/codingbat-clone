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
                <div class="form-group">
                    <label>
                        <input type="checkbox" id="signup-admin"> Register as Admin
                    </label>
                </div>
                <button type="submit" class="btn btn-primary">Sign Up</button>
                <p class="error-message" id="signup-error"></p>
            </form>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const loginForm = document.getElementById('login-form');
        const signupForm = document.getElementById('signup-form');
        const loginTab = document.querySelector('[data-tab="login"]');
        const signupTab = document.querySelector('[data-tab="signup"]');
        const loginError = document.getElementById('login-error');
        const signupError = document.getElementById('signup-error');

        loginTab.addEventListener('click', () => {
            loginTab.classList.add('active');
            signupTab.classList.remove('active');
            loginForm.style.display = 'block';
            signupForm.style.display = 'none';
            loginError.textContent = '';
            signupError.textContent = '';
        });

        signupTab.addEventListener('click', () => {
            signupTab.classList.add('active');
            loginTab.classList.remove('active');
            signupForm.style.display = 'block';
            loginForm.style.display = 'none';
            loginError.textContent = '';
            signupError.textContent = '';
        });
    });

</script>

<script src="assets/js/theme.js"></script>
</body>
</html>
