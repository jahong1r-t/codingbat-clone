document.addEventListener('DOMContentLoaded', () => {
    // DOM elements
    const problemModal = document.getElementById('problem-modal');
    const editProblemModal = document.getElementById('edit-problem-modal');
    const problemForm = document.getElementById('problem-form');
    const editProblemForm = document.getElementById('edit-problem-form');
    const problemIdInput = document.getElementById('problem-id');
    const testCasesContainer = document.getElementById('test-cases-container');
    const addTestCaseBtn = document.getElementById('add-test-case-btn');
    const cancelBtn = document.getElementById('cancel-btn');
    const closeBtn = problemModal.querySelector('.close-btn');
    const addProblemBtn = document.getElementById('add-problem-btn');
    const modalTitle = document.getElementById('modal-title');

    // Edit modal DOM elements
    const editCloseBtn = editProblemModal.querySelector('.close-btn');
    const editCancelBtn = document.getElementById('edit-cancel-btn');
    const editTestCasesContainer = document.getElementById('edit-test-cases-container');
    const editAddTestCaseBtn = document.getElementById('edit-add-test-case-btn');

    /**
     * Add test case input
     */
    function addTestCaseInput(container, testCase = null) {
        const template = document.getElementById('test-case-editor-template');
        const element = template.content.cloneNode(true);

        if (testCase) {
            element.querySelector('.test-input').value = testCase.input || '';
            element.querySelector('.test-output').value = testCase.output || '';
            element.querySelector('.test-hidden').checked = testCase.hidden || false;
        }

        element.querySelector('.remove-test-case-btn').addEventListener('click', (e) => {
            e.target.closest('.test-case-editor').remove();
        });

        container.appendChild(element);
    }

    /**
     * Open modal for adding a new problem
     */
    function openAddProblemModal() {
        problemForm.reset();
        problemIdInput.value = '';
        testCasesContainer.innerHTML = '';
        modalTitle.textContent = 'Add New Problem';
        problemModal.classList.add('active');
    }

    /**
     * Open modal for editing a problem
     */
    function openEditProblemModal(problemId) {
        const problemElement = document.querySelector(`.admin-problem-item[data-problem-id="${problemId}"]`);
        if (!problemElement) {
            console.error('Problem element not found for ID:', problemId);
            return;
        }

        const problem = {
            id: problemElement.getAttribute('data-problem-id') || '',
            title: problemElement.getAttribute('data-title') || '',
            difficulty: problemElement.getAttribute('data-difficulty') || 'easy',
            description: problemElement.getAttribute('data-description') || '',
            template: problemElement.getAttribute('data-template') || '',
            testCases: JSON.parse(problemElement.getAttribute('data-test-cases') || '[]')
        };

        // Edit modal formani to'ldirish
        editProblemForm.reset();
        document.getElementById('edit-problem-id').value = problem.id;
        document.getElementById('edit-problem-title-input').value = problem.title;
        document.getElementById('edit-problem-difficulty-select').value = problem.difficulty;
        document.getElementById('edit-problem-description-input').value = problem.description;
        document.getElementById('edit-problem-template-input').value = problem.template;

        editTestCasesContainer.innerHTML = '';
        problem.testCases.forEach(testCase => {
            addTestCaseInput(editTestCasesContainer, testCase);
        });

        editProblemModal.classList.add('active');
    }

    /**
     * Close modals
     */
    function closeProblemModal() {
        problemModal.classList.remove('active');
    }

    function closeEditProblemModal() {
        editProblemModal.classList.remove('active');
    }

    // Event listeners for Add Problem Modal
    addProblemBtn.addEventListener('click', openAddProblemModal);

    closeBtn.addEventListener('click', closeProblemModal);
    cancelBtn.addEventListener('click', closeProblemModal);

    addTestCaseBtn.addEventListener('click', () => {
        addTestCaseInput(testCasesContainer);
    });

    problemModal.addEventListener('click', (e) => {
        if (e.target === problemModal) {
            closeProblemModal();
        }
    });

    problemForm.addEventListener('submit', (e) => {
        e.preventDefault();
        console.log('Add Problem Form submitted');
        // TODO: Serverga yangi muammoni yuborish logikasi qo'shiladi
        closeProblemModal();
    });

    // Event listeners for Edit Problem Modal
    document.getElementById('admin-problem-list').addEventListener('click', (e) => {
        const editButton = e.target.closest('.edit-problem-btn');
        if (editButton) {
            const problemId = editButton.closest('.admin-problem-item').getAttribute('data-problem-id');
            openEditProblemModal(problemId);
        }
    });

    editCloseBtn.addEventListener('click', closeEditProblemModal);
    editCancelBtn.addEventListener('click', closeEditProblemModal);

    editAddTestCaseBtn.addEventListener('click', () => {
        addTestCaseInput(editTestCasesContainer);
    });

    editProblemModal.addEventListener('click', (e) => {
        if (e.target === editProblemModal) {
            closeEditProblemModal();
        }
    });

    editProblemForm.addEventListener('submit', (e) => {
        e.preventDefault();
        console.log('Edit Problem Form submitted');
        // TODO: Serverga tahrirlangan muammoni yuborish logikasi qo'shiladi
        closeEditProblemModal();
    });
});
