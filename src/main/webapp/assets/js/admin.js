/**
 * Admin Panel Handler
 */
document.addEventListener('DOMContentLoaded', () => {
    // Get current user
    const currentUser = StorageService.getCurrentUser();

    // Verify admin access
    if (!currentUser || !currentUser.isAdmin) {
        window.location.href = 'dashboard.html';
        return;
    }

    // DOM elements
    const adminProblemList = document.getElementById('admin-problem-list');
    const addProblemBtn = document.getElementById('add-problem-btn');
    const problemModal = document.getElementById('problem-modal');
    const modalTitle = document.getElementById('modal-title');
    const problemForm = document.getElementById('problem-form');
    const problemIdInput = document.getElementById('problem-id');
    const problemTitleInput = document.getElementById('problem-title-input');
    const problemDifficultySelect = document.getElementById('problem-difficulty-select');
    const problemDescriptionInput = document.getElementById('problem-description-input');
    const problemTemplateInput = document.getElementById('problem-template-input');
    const testCasesContainer = document.getElementById('test-cases-container');
    const addTestCaseBtn = document.getElementById('add-test-case-btn');
    const cancelBtn = document.getElementById('cancel-btn');
    const closeBtn = document.querySelector('.close-btn');

    /**
     * Load and display problems in admin panel
     */
    function loadProblems() {
        const problems = StorageService.getProblems();

        // Clear problem list
        adminProblemList.innerHTML = '';

        if (problems.length === 0) {
            adminProblemList.innerHTML = `
        <div class="text-center" style="padding: var(--space-3);">
          <p>No problems found. Add your first problem!</p>
        </div>
      `;
            return;
        }

        problems.forEach(problem => {
            // Clone template
            const template = document.getElementById('admin-problem-item-template');
            const item = template.content.cloneNode(true);

            // Fill in problem data
            item.querySelector('.admin-problem-title').textContent = problem.title;

            const difficultyElement = item.querySelector('.admin-problem-difficulty');
            difficultyElement.textContent = problem.difficulty;
            difficultyElement.classList.add(`difficulty-${problem.difficulty}`);

            item.querySelector('.admin-problem-test-count').textContent =
                `${problem.testCases.length} test case${problem.testCases.length !== 1 ? 's' : ''}`;

            // Set up edit button
            const editBtn = item.querySelector('.edit-problem-btn');
            editBtn.addEventListener('click', () => {
                openEditProblemModal(problem);
            });

            // Set up delete button
            const deleteBtn = item.querySelector('.delete-problem-btn');
            deleteBtn.addEventListener('click', () => {
                if (confirm(`Are you sure you want to delete "${problem.title}"?`)) {
                    StorageService.deleteProblem(problem.id);
                    loadProblems();
                }
            });

            // Add item to list
            adminProblemList.appendChild(item);
        });
    }

    /**
     * Setup test cases accordion if there are 2 or more test cases
     */
    function setupTestCasesAccordion() {
        const testCaseElements = testCasesContainer.querySelectorAll('.test-case-editor, .test-case-accordion-item');

        // Agar 2 yoki undan ko'p test case bo'lsa
        if (testCaseElements.length >= 2) {
            // Agar accordion mavjud bo'lmasa, yaratamiz
            if (!testCasesContainer.querySelector('.test-cases-accordion')) {
                // Accordion konteynerini yaratamiz
                const accordion = document.createElement('div');
                accordion.className = 'test-cases-accordion';

                // Avvalgi elementlarni saqlab olamiz
                const testCases = Array.from(testCaseElements).map(element => ({
                    input: element.querySelector('.test-input').value,
                    output: element.querySelector('.test-output').value,
                    hidden: element.querySelector('.test-hidden').checked
                }));

                testCasesContainer.innerHTML = '';
                testCasesContainer.appendChild(accordion);

                // Test caselarni accordionga joylaymiz
                testCases.forEach((testCase, index) => {
                    const accordionItem = document.createElement('div');
                    accordionItem.className = 'test-case-accordion-item';

                    // Yangi qo'shilgan test caseni ochiq qilamiz
                    if (index === testCases.length - 1) {
                        accordionItem.classList.add('active');
                    }

                    accordionItem.innerHTML = `
          <div class="test-case-accordion-header">
            <h5>Test Case ${index + 1} ${testCase.hidden ? '(Hidden)' : ''}</h5>
            <i class="fas fa-chevron-down test-case-accordion-icon"></i>
          </div>
          <div class="test-case-accordion-content">
            <div class="form-group">
              <label>Input</label>
              <textarea class="test-input" rows="3" required>${testCase.input}</textarea>
            </div>
            <div class="form-group">
              <label>Expected Output</label>
              <textarea class="test-output" rows="3" required>${testCase.output}</textarea>
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" class="test-hidden" ${testCase.hidden ? 'checked' : ''}>
                Hidden Test Case (not shown to users)
              </label>
            </div>
            <button type="button" class="btn btn-danger remove-test-case-btn">
              <i class="fas fa-trash"></i> Remove
            </button>
          </div>
        `;

                    // Header bosilganda toggle qilish
                    accordionItem.querySelector('.test-case-accordion-header').addEventListener('click', () => {
                        accordionItem.classList.toggle('active');
                    });

                    // O'chirish tugmasi
                    accordionItem.querySelector('.remove-test-case-btn').addEventListener('click', () => {
                        accordionItem.remove();
                        // Agar 1 ta test case qolsa, accordionni olib tashlaymiz
                        if (accordion.querySelectorAll('.test-case-accordion-item').length < 2) {
                            const remainingCase = accordion.querySelector('.test-case-accordion-item');
                            const testCaseData = {
                                input: remainingCase.querySelector('.test-input').value,
                                output: remainingCase.querySelector('.test-output').value,
                                hidden: remainingCase.querySelector('.test-hidden').checked
                            };

                            testCasesContainer.innerHTML = '';
                            addTestCaseInput(testCaseData, false); // Rekursiyaga olib kelmaslik uchun
                        }
                    });

                    accordion.appendChild(accordionItem);
                });
            }
        }
        // Agar 1 ta test case bo'lsa, oddiy ko'rinishga qaytaramiz
        else if (testCaseElements.length === 1 && testCasesContainer.querySelector('.test-cases-accordion')) {
            const testCaseData = {
                input: testCaseElements[0].querySelector('.test-input').value,
                output: testCaseElements[0].querySelector('.test-output').value,
                hidden: testCaseElements[0].querySelector('.test-hidden').checked
            };

            testCasesContainer.innerHTML = '';
            addTestCaseInput(testCaseData, false); // Rekursiyaga olib kelmaslik uchun
        }
    }

    /**
     * Add a new test case input to the form
     * @param {Object} testCase - Optional test case data for editing
     */
    function addTestCaseInput(testCase = null, checkAccordion = true) {
        // Clone template
        const template = document.getElementById('test-case-editor-template');
        const element = template.content.cloneNode(true);

        // Fill in test case data if editing
        if (testCase) {
            element.querySelector('.test-input').value = testCase.input;
            element.querySelector('.test-output').value = testCase.output;
            element.querySelector('.test-hidden').checked = testCase.hidden;
        }

        // Set up remove button
        element.querySelector('.remove-test-case-btn').addEventListener('click', (e) => {
            e.target.closest('.test-case-editor, .test-case-accordion-item').remove();
            setupTestCasesAccordion();
        });

        // Add to container
        if (testCasesContainer.querySelector('.test-cases-accordion')) {
            // Agar accordion mavjud bo'lsa, yangi accordion item qo'shamiz
            const accordion = testCasesContainer.querySelector('.test-cases-accordion');
            const accordionItem = document.createElement('div');
            accordionItem.className = 'test-case-accordion-item active';

            accordionItem.innerHTML = `
      <div class="test-case-accordion-header">
        <h5>Test Case ${accordion.children.length + 1} ${testCase?.hidden ? '(Hidden)' : ''}</h5>
        <i class="fas fa-chevron-down test-case-accordion-icon"></i>
      </div>
      <div class="test-case-accordion-content">
        <div class="form-group">
          <label>Input</label>
          <textarea class="test-input" rows="3" required>${testCase?.input || ''}</textarea>
        </div>
        <div class="form-group">
          <label>Expected Output</label>
          <textarea class="test-output" rows="3" required>${testCase?.output || ''}</textarea>
        </div>
        <div class="form-group">
          <label>
            <input type="checkbox" class="test-hidden" ${testCase?.hidden ? 'checked' : ''}>
            Hidden Test Case (not shown to users)
          </label>
        </div>
        <button type="button" class="btn btn-danger remove-test-case-btn">
          <i class="fas fa-trash"></i> Remove
        </button>
      </div>
    `;

            // Header bosilganda toggle qilish
            accordionItem.querySelector('.test-case-accordion-header').addEventListener('click', () => {
                accordionItem.classList.toggle('active');
            });

            // O'chirish tugmasi
            accordionItem.querySelector('.remove-test-case-btn').addEventListener('click', () => {
                accordionItem.remove();
                setupTestCasesAccordion();
            });

            // Avvalgi barcha test caselarni yopamiz
            accordion.querySelectorAll('.test-case-accordion-item').forEach(item => {
                if (item !== accordionItem) item.classList.remove('active');
            });

            accordion.appendChild(accordionItem);
        } else {
            // Oddiy ko'rinishda qo'shamiz
            testCasesContainer.appendChild(element);
            if (checkAccordion) {
                setupTestCasesAccordion();
            }
        }
    }

    /**
     * Get test cases from either accordion or normal view
     */
    function getTestCases() {
        if (testCasesContainer.querySelector('.test-cases-accordion')) {
            const testCases = [];
            testCasesContainer.querySelectorAll('.test-case-accordion-item').forEach(item => {
                testCases.push({
                    input: item.querySelector('.test-input').value,
                    output: item.querySelector('.test-output').value,
                    hidden: item.querySelector('.test-hidden').checked
                });
            });
            return testCases;
        } else {
            return Array.from(testCasesContainer.querySelectorAll('.test-case-editor')).map(editor => ({
                input: editor.querySelector('.test-input').value,
                output: editor.querySelector('.test-output').value,
                hidden: editor.querySelector('.test-hidden').checked
            }));
        }
    }

    /**
     * Open modal for adding a new problem
     */
    function openAddProblemModal() {
        // Clear form
        problemForm.reset();
        problemIdInput.value = '';
        testCasesContainer.innerHTML = '';

        // Set modal title
        modalTitle.textContent = 'Add New Problem';

        // Add empty test case
        addTestCaseInput();

        // Show modal
        problemModal.classList.add('active');
    }

    /**
     * Open modal for editing a problem
     * @param {Object} problem - Problem data
     */
    function openEditProblemModal(problem) {
        // Set form values
        problemIdInput.value = problem.id;
        problemTitleInput.value = problem.title;
        problemDifficultySelect.value = problem.difficulty;
        problemDescriptionInput.value = problem.description;
        problemTemplateInput.value = problem.template;

        // Clear test cases
        testCasesContainer.innerHTML = '';

        // Add test cases
        problem.testCases.forEach(testCase => {
            addTestCaseInput(testCase);
        });

        // Set modal title
        modalTitle.textContent = 'Edit Problem';

        // Show modal
        problemModal.classList.add('active');
    }

    /**
     * Close problem modal
     */
    function closeProblemModal() {
        problemModal.classList.remove('active');
    }

    /**
     * Save problem
     * @param {Event} e - Form submit event
     */
    function saveProblem(e) {
        e.preventDefault();

        // Get form values
        const id = problemIdInput.value;
        const title = problemTitleInput.value;
        const difficulty = problemDifficultySelect.value;
        const description = problemDescriptionInput.value;
        const template = problemTemplateInput.value;

        // Get test cases
        const testCases = getTestCases();

        // Validate at least one test case
        if (testCases.length === 0) {
            alert('Please add at least one test case');
            return;
        }

        // Create problem object
        const problem = {
            title,
            difficulty,
            description,
            template,
            testCases
        };

        // Save problem
        if (id) {
            // Update existing problem
            StorageService.updateProblem(id, problem);
        } else {
            // Add new problem
            StorageService.addProblem(problem);
        }

        // Close modal and reload problems
        closeProblemModal();
        loadProblems();
    }

    // Event listeners
    addProblemBtn.addEventListener('click', openAddProblemModal);
    closeBtn.addEventListener('click', closeProblemModal);
    cancelBtn.addEventListener('click', closeProblemModal);
    problemForm.addEventListener('submit', saveProblem);

    addTestCaseBtn.addEventListener('click', () => {
        addTestCaseInput();
    });

    // Close modal when clicking outside
    problemModal.addEventListener('click', (e) => {
        if (e.target === problemModal) {
            closeProblemModal();
        }
    });

    // Initial load
    loadProblems();
});
