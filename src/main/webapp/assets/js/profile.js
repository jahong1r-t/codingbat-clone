document.addEventListener('DOMContentLoaded', () => {
    const activityGrid = document.getElementById('activity-grid');
    const rawData = activityGrid?.getAttribute('data-activity');
    const activityData = rawData ? JSON.parse(rawData) : {};

    console.log("Activity Data:", activityData);

    function generateActivityGrid() {
        if (!activityGrid) {
            console.error("Activity grid element not found!");
            return;
        }

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        const startDate = new Date(today);
        startDate.setDate(today.getDate() - 364); // 1 yil

        activityGrid.innerHTML = '';

        for (let i = 0; i < 365; i++) {
            const currentDate = new Date(startDate);
            currentDate.setDate(startDate.getDate() + i);

            const isoDate = currentDate.toISOString().split('T')[0];
            const activityCount = activityData[isoDate] || 0;
            const level = calculateActivityLevel(activityCount);

            const square = document.createElement('div');
            square.className = `activity-square level-${level}`;
            square.title = `${isoDate}: ${activityCount} problems solved`;
            square.setAttribute('data-date', isoDate);
            square.setAttribute('data-count', activityCount);

            activityGrid.appendChild(square);
        }
    }

    function calculateActivityLevel(count) {
        if (count <= 0) return 0;
        if (count >= 4) return 4;
        if (count >= 3) return 3;
        if (count >= 2) return 2;
        return 1;
    }

    // Modal
    const editProfileBtn = document.getElementById('edit-profile-btn');
    const editProfileModal = document.getElementById('edit-profile-modal');
    const cancelEditBtn = document.getElementById('cancel-edit-btn');
    const closeBtn = document.querySelector('.close-btn');

    function openEditModal() {
        editProfileModal?.classList.add('active');
    }

    function closeEditModal() {
        editProfileModal?.classList.remove('active');
    }

    // Event listeners
    editProfileBtn?.addEventListener('click', openEditModal);
    cancelEditBtn?.addEventListener('click', closeEditModal);
    closeBtn?.addEventListener('click', closeEditModal);

    editProfileModal?.addEventListener('click', (e) => {
        if (e.target === editProfileModal) {
            closeEditModal();
        }
    });

    generateActivityGrid();
});
