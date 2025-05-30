document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('login-form');
    const signupForm = document.getElementById('signup-form');
    const loginTab = document.querySelector('[data-tab="login"]');
    const signupTab = document.querySelector('[data-tab="signup"]');
    const loginError = document.getElementById('login-error');
    const signupError = document.getElementById('signup-error');

    // Function to switch to Sign Up tab
    const switchToSignUp = () => {
        signupTab.classList.add('active');
        loginTab.classList.remove('active');
        signupForm.style.display = 'block';
        loginForm.style.display = 'none';
        loginError.textContent = '';
        signupError.textContent = '';
    };

    // Function to switch to Sign In tab
    const switchToSignIn = () => {
        loginTab.classList.add('active');
        signupTab.classList.remove('active');
        loginForm.style.display = 'block';
        signupForm.style.display = 'none';
        loginError.textContent = '';
        signupError.textContent = '';
    };

    // Check URL parameter to determine default tab
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('tab') === 'signup') {
        switchToSignUp();
    } else {
        switchToSignIn();
    }

    // Event listeners for tab switching
    loginTab.addEventListener('click', switchToSignIn);
    signupTab.addEventListener('click', switchToSignUp);
});
