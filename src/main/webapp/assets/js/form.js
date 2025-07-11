document.addEventListener('DOMContentLoaded', () => {
    const testCasesContainer = document.getElementById('test-cases-container');
    const addTestCaseBtn = document.getElementById('add-test-case');
    let testCaseCounter = 0;

    // Add test case functionality
    function addTestCase() {
        testCaseCounter++;
        const template = document.getElementById('test-case-template');
        const element = template.content.cloneNode(true);

        // Update header
        element.querySelector('h4').textContent = `Test Case ${testCaseCounter}`;

        // Add remove functionality
        const removeBtn = element.querySelector('.remove-test-case');
        removeBtn.addEventListener('click', () => {
            if (confirm('Are you sure you want to remove this test case?')) {
                removeBtn.closest('.test-case-item').remove();
                updateTestCaseNumbers();
            }
        });

        testCasesContainer.appendChild(element);
    }

    function updateTestCaseNumbers() {
        const testCases = testCasesContainer.querySelectorAll('.test-case-item');
        testCases.forEach((testCase, index) => {
            testCase.querySelector('h4').textContent = `Test Case ${index + 1}`;
        });
        testCaseCounter = testCases.length;
    }

    // Add initial test case
    addTestCase();

    // Add test case button handler
    addTestCaseBtn.addEventListener('click', () => {
        addTestCase();
    });
});