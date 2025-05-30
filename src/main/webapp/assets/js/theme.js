document.addEventListener('DOMContentLoaded', () => {
    const themeToggle = document.querySelector('.theme-toggle');
    const logoImg = document.querySelector('#logo-img');

    const savedTheme = localStorage.getItem('code_challenger_theme');
    if (savedTheme === 'dark') {
        document.body.classList.add('dark-theme');
        logoImg.src = 'assets/img/logo-white.png';
        themeToggle.innerHTML = '<i class="fas fa-sun"></i>';
        if (window.codeMirrorEditor) {
            window.codeMirrorEditor.setOption('theme', 'dracula');
        }
    } else {
        document.body.classList.remove('dark-theme');
        logoImg.src = 'assets/img/logo-black.png';
        themeToggle.innerHTML = '<i class="fas fa-moon"></i>';
        if (window.codeMirrorEditor) {
            window.codeMirrorEditor.setOption('theme', 'default');
        }
    }

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            document.body.classList.toggle('dark-theme');

            const isDark = document.body.classList.contains('dark-theme');
            logoImg.src = isDark ? 'assets/img/logo-white.png' : 'assets/img/logo-black.png';
            themeToggle.innerHTML = isDark ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';

            if (window.codeMirrorEditor) {
                window.codeMirrorEditor.setOption('theme', isDark ? 'dracula' : 'default');
            }

            localStorage.setItem('code_challenger_theme', isDark ? 'dark' : 'light');
        });
    }
});
