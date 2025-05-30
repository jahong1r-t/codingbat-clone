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
