function showToast(message, type = 'error', duration = 3000) {
    // Toast elementini yaratish
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;

    // Toast kontenti
    toast.innerHTML = `
        <div class="toast-content">
            <span class="toast-message">${message}</span>
            <button class="toast-close" onclick="this.parentElement.parentElement.remove()">×</button>
        </div>
    `;

    // Toast konteyneriga qo'shish
    container.appendChild(toast);

    // Avtomatik yopilish
    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => {
            toast.remove();
        }, 300); // Animatsiya vaqti bilan sinxronlash
    }, duration);
}

// Sahifa yuklanganda serverdan kelgan xabarlarni tekshirish
document.addEventListener('DOMContentLoaded', () => {
    const toastData = window.toastData || {};
    if (toastData.errorMsg) {
        showToast(toastData.errorMsg, 'error');
    } else if (toastData.successMsg) {
        showToast(toastData.successMsg, 'success');
    }
});
