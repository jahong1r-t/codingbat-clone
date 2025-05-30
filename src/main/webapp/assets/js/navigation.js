/**
 * Navigation and Authentication Handler
 */
document.addEventListener('DOMContentLoaded', () => {
  // Check if user is logged in
  const currentUser = StorageService.getCurrentUser();
  
  // If not logged in and not on login page, redirect to login
  if (!currentUser && !window.location.pathname.includes('index.html')) {
    window.location.href = 'index.html';
    return;
  }
  
  // Handle logout button
  const logoutBtn = document.getElementById('logout-btn');
  if (logoutBtn) {
    logoutBtn.addEventListener('click', () => {
      StorageService.clearCurrentUser();
      window.location.href = 'index.html';
    });
  }
  
  // Handle admin panel link
  const adminLink = document.getElementById('admin-link');
  if (adminLink) {
    if (currentUser && currentUser.isAdmin) {
      adminLink.classList.remove('hidden');
      adminLink.addEventListener('click', () => {
        window.location.href = 'admin.html';
      });
    }
  }
  
  // Handle problems link (back to dashboard)
  const problemsLink = document.getElementById('problems-link');
  if (problemsLink) {
    problemsLink.addEventListener('click', () => {
      window.location.href = 'dashboard.html';
    });
  }
});