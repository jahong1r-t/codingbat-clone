document.addEventListener('DOMContentLoaded', () => {
    const testCasesContainer = document.getElementById('test-cases-container');
    const addTestCaseBtn = document.getElementById('add-test-case');
    const problemForm = document.getElementById('problem-form');
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

    // Validate form inputs
    function validateForm() {
        const title = document.getElementById('problem-title').value.trim();
        const difficulty = document.getElementById('problem-difficulty').value;
        const description = document.getElementById('problem-description').value.trim();
        const codeTemplate = document.getElementById('problem-template').value.trim();
        const testCases = Array.from(document.querySelectorAll('.test-case-item'));

        if (!title) {
            alert('Problem title is required');
            return false;
        }

        if (!difficulty) {
            alert('Difficulty level is required');
            return false;
        }

        if (!description) {
            alert('Problem description is required');
            return false;
        }

        if (!codeTemplate) {
            alert('Code template is required');
            return false;
        }

        if (testCases.length === 0) {
            alert('At least one test case is required');
            return false;
        }

        // Validate each test case
        for (let i = 0; i < testCases.length; i++) {
            const testCase = testCases[i];
            const input = testCase.querySelector('.test-input').value.trim();
            const output = testCase.querySelector('.test-output').value.trim();

            if (!input) {
                alert(`Input for Test Case ${i + 1} cannot be empty`);
                return false;
            }

            if (!output) {
                alert(`Output for Test Case ${i + 1} cannot be empty`);
                return false;
            }
        }

        return true;
    }

    // Add initial test case
    addTestCase();

    // Add test case button handler
    addTestCaseBtn.addEventListener('click', () => {
        addTestCase();
    });

    // Form submission handler
    problemForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        // Validate form before submission
        if (!validateForm()) {
            return;
        }

        // Get submit button and set loading state
        const submitBtn = this.querySelector('button[type="submit"]');
        const originalBtnText = submitBtn.innerHTML;
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';

        try {
            // Collect all test cases - ensure field names match DTO
            const testCases = Array.from(document.querySelectorAll('.test-case-item')).map(testCaseEl => {
                return {
                    input: testCaseEl.querySelector('.test-input').value.trim(),
                    output: testCaseEl.querySelector('.test-output').value.trim(), // Must match TestCaseDTO
                    hidden: testCaseEl.querySelector('.hidden-checkbox').checked
                };
            });

            // Prepare the data object - ensure field names match ProblemDTO
            const problemData = {
                title: document.getElementById('problem-title').value.trim(),
                difficulty: document.getElementById('problem-difficulty').value, // String, not enum
                description: document.getElementById('problem-description').value.trim(),
                codeTemplate: document.getElementById('problem-template').value.trim(), // Must match DTO
                testCases: testCases
            };

            console.log('Submitting problem data:', JSON.stringify(problemData, null, 2));

            const response = await fetch('/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify(problemData)
            });

            const result = await response.json();

            if (!response.ok) {
                throw new Error(result.message || result.error || 'Failed to create problem');
            }

            // Show success message and redirect
            alert('Problem created successfully!');
            window.location.href = '/admin';

        } catch (error) {
            console.error('Submission error:', error);

            // Show user-friendly error message
            const errorMessage = error.message.includes('JSON')
                ? 'Invalid data format. Please check your inputs.'
                : error.message;

            alert(`Error: ${errorMessage}`);
        } finally {
            // Reset button state
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalBtnText;
        }
    });

    // Add input validation for test cases
    testCasesContainer.addEventListener('input', (e) => {
        if (e.target.classList.contains('test-input') ||
            e.target.classList.contains('test-output')) {
            const input = e.target.value.trim();
            const testCaseItem = e.target.closest('.test-case-item');

            if (input) {
                testCaseItem.classList.remove('invalid-case');
            } else {
                testCaseItem.classList.add('invalid-case');
            }
        }
    });
});