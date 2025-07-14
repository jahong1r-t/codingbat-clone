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

    const startDate = new Date('2025-01-01');
    const endDate = new Date('2025-12-31');
    startDate.setHours(0, 0, 0, 0);
    endDate.setHours(0, 0, 0, 0);

    activityGrid.innerHTML = '';

    const firstSunday = new Date(startDate);
    firstSunday.setDate(startDate.getDate() - startDate.getDay());

    const weeksCount = Math.ceil((endDate - firstSunday) / (7 * 24 * 60 * 60 * 1000));

    for (let row = 0; row < 7; row++) {
        for (let col = 0; col < weeksCount; col++) {
            const dayOffset = col * 7 + row;
            const current = new Date(firstSunday);
            current.setDate(firstSunday.getDate() + dayOffset);
            current.setHours(0, 0, 0, 0);

            if (current < startDate || current > endDate) {
                // Belgilangan oraliqdan tashqarida bo'lsa, bo'sh katak qo'shish
                const emptySquare = document.createElement('div');
                emptySquare.className = 'activity-square level-0 empty';
                activityGrid.appendChild(emptySquare);
                continue;
            }

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