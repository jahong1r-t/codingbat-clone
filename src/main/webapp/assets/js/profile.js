document.addEventListener('DOMContentLoaded', function () {
    const activityGrid = document.getElementById('activity-grid');
    const raw = activityGrid?.getAttribute('data-activity') || '{}';

    const activityData = {};
    const cleaned = raw.replace(/[{}]/g, '');
    const entries = cleaned.split(', ');

    for (let entry of entries) {
        const [date, count] = entry.split('=');
        if (date && count) {
            activityData[date.trim()] = parseInt(count.trim());
        }
    }

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const lastSunday = new Date(today);
    lastSunday.setDate(today.getDate() - today.getDay());

    const startDate = new Date(lastSunday);
    startDate.setDate(startDate.getDate() - 52 * 7);

    activityGrid.innerHTML = '';

    for (let row = 0; row < 7; row++) {
        for (let col = 0; col < 53; col++) {
            const offset = col * 7 + row;
            const current = new Date(startDate);
            current.setDate(startDate.getDate() + offset);
            current.setHours(0, 0, 0, 0);

            if (current > today) continue;

            const iso = formatDate(current);
            const count = activityData[iso] || 0;
            const level = getLevel(count);

            const square = document.createElement('div');
            square.className = `activity-square level-${level}`;
            square.title = `${iso}: ${count} solved`;

            activityGrid.appendChild(square);
        }
    }

    function formatDate(date) {
        return date.toLocaleDateString('sv');
    }

    function getLevel(count) {
        if (count <= 0) return 0;
        if (count >= 10) return 4;
        if (count >= 5) return 3;
        if (count >= 3) return 2;
        return 1;
    }

});
