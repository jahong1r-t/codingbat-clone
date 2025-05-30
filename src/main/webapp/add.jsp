<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>CodingBat - Admin Panel</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/admin.css">
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-container">
    <nav class="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/">
                <img id="logo-img" src="assets/img/logo-black.png" width="150px" alt="logo"/>
            </a>
        </div>
        <div class="navbar-menu">
            <div class="theme-toggle">
                <i class="fas fa-moon"></i>
            </div>
            <a href="${pageContext.request.contextPath}/">
                <button id="problems-link" class="btn btn-primary">
                    <i class="fas fa-list"></i> Problems
                </button>
            </a>
            <a href="${pageContext.request.contextPath}/logout">
                <button id="login-btn" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt"></i> Log out
                </button>
            </a>
        </div>
    </nav>

    <main class="admin-container">
        <header class="admin-header">
            <h2>Admin Panel</h2>
            <button id="add-problem-btn" class="btn btn-primary">
                <i class="fas fa-plus"></i> Add New Problem
            </button>
        </header>

        <div class="statistics-grid">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <div class="stat-content">
                    <h3>Total Users</h3>
                    <p id="total-users">0</p>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-code"></i>
                <div class="stat-content">
                    <h3>Total Problems</h3>
                    <p id="total-problems">0</p>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <div class="stat-content">
                    <h3>Latest Problem</h3>
                    <p id="latest-problem">None</p>
                    <small id="latest-problem-date"></small>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-star"></i>
                <div class="stat-content">
                    <h3>Most Solved</h3>
                    <p id="most-solved">None</p>
                    <small id="most-solved-count"></small>
                </div>
            </div>
        </div>

        <div class="admin-content">
            <div class="problem-management">
                <h3>Manage Problems</h3>
                <div class="admin-problem-list" id="admin-problem-list">
                    <div class="admin-problem-item"
                         data-problem-id="1"
                         data-title="FizBuzz"
                         data-difficulty="hard"
                         data-description="Write a program that prints the numbers from 1 to n. But for multiples of three print 'Fizz' instead of the number and for the multiples of five print 'Buzz'."
                         data-template="public String fizBuzz(int n) { return ''; }"
                         data-test-cases='[{"input":"3","output":"Fizz","hidden":false},{"input":"5","output":"Buzz","hidden":true},{"input":"15","output":"FizzBuzz","hidden":false}]'>
                        <div class="admin-problem-info">
                            <h4 class="admin-problem-title">FizBuzz</h4>
                            <div class="admin-problem-meta">
                                <span class="admin-problem-difficulty difficulty-hard">Hard</span>
                                <span class="admin-problem-test-count">3</span>
                            </div>
                        </div>
                        <div class="admin-problem-actions">
                            <button class="btn btn-secondary edit-problem-btn">
                                <i class="fas fa-edit"></i> Edit
                            </button>
                            <button class="btn btn-danger delete-problem-btn">
                                <i class="fas fa-trash"></i> Delete
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Modal for adding problems -->
    <div class="modal" id="problem-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modal-title">Add New Problem</h3>
                <button class="close-btn">×</button>
            </div>
            <div class="modal-body">
                <form id="problem-form">
                    <input type="hidden" id="problem-id">
                    <div class="form-group">
                        <label for="problem-title-input">Title</label>
                        <input type="text" id="problem-title-input" required>
                    </div>
                    <div class="form-group">
                        <label for="problem-difficulty-select">Difficulty</label>
                        <select id="problem-difficulty-select" required>
                            <option value="easy">Easy</option>
                            <option value="medium">Medium</option>
                            <option value="hard">Hard</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="problem-description-input">Description</label>
                        <textarea id="problem-description-input" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="problem-template-input">Code Template</label>
                        <textarea id="problem-template-input" rows="5" required></textarea>
                    </div>

                    <div class="test-cases-section">
                        <div class="test-cases-header">
                            <h4>Test Cases</h4>
                            <button type="button" id="add-test-case-btn" class="btn btn-secondary">
                                <i class="fas fa-plus"></i> Add Test Case
                            </button>
                        </div>
                        <div id="test-cases-container">
                            <!-- Test cases will be added here -->
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-outline" id="cancel-btn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Problem</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal for editing problems -->
    <div class="modal" id="edit-problem-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Problem</h3>
                <button class="close-btn">×</button>
            </div>
            <div class="modal-body">
                <form id="edit-problem-form">
                    <input type="hidden" id="edit-problem-id">
                    <div class="form-group">
                        <label for="edit-problem-title-input">Title</label>
                        <input type="text" id="edit-problem-title-input" required>
                    </div>
                    <div class="form-group">
                        <label for="edit-problem-difficulty-select">Difficulty</label>
                        <select id="edit-problem-difficulty-select" required>
                            <option value="easy">Easy</option>
                            <option value="medium">Medium</option>
                            <option value="hard">Hard</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="edit-problem-description-input">Description</label>
                        <textarea id="edit-problem-description-input" rows="3" required></textarea>
                    </div>
                    <div class="form-group">
                        <label for="edit-problem-template-input">Code Template</label>
                        <textarea id="edit-problem-template-input" rows="5" required></textarea>
                    </div>

                    <div class="test-cases-section">
                        <div class="test-cases-header">
                            <h4>Test Cases</h4>
                            <button type="button" id="edit-add-test-case-btn" class="btn btn-secondary">
                                <i class="fas fa-plus"></i> Add Test Case
                            </button>
                        </div>
                        <div id="edit-test-cases-container">
                            <!-- Test cases will be added here -->
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn btn-outline" id="edit-cancel-btn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Problem</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Test case template -->
    <template id="test-case-editor-template">
        <div class="test-case-editor">
            <div class="test-case-header">
                <h5>Test Case</h5>
                <button type="button" class="btn btn-danger remove-test-case-btn">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
            <div class="test-case-inputs">
                <div class="form-group">
                    <label>Input</label>
                    <label>
                        <textarea class="test-input" rows="2" required></textarea>
                    </label>
                </div>
                <div class="form-group">
                    <label>Expected Output</label>
                    <label>
                        <textarea class="test-output" rows="2" required></textarea>
                    </label>
                </div>
                <div class="form-group">
                    <label>
                        <input type="checkbox" class="test-hidden"> Hidden Test Case (not shown to users)
                    </label>
                </div>
            </div>
        </div>
    </template>

    <!-- Admin problem item template -->
    <template id="admin-problem-item-template">
        <div class="admin-problem-item">
            <div class="admin-problem-info">
                <h4 class="admin-problem-title"></h4>
                <div class="admin-problem-meta">
                    <span class="admin-problem-difficulty"></span>
                    <span class="admin-problem-test-count"></span>
                </div>
            </div>
            <div class="admin-problem-actions">
                <button class="btn btn-secondary edit-problem-btn">
                    <i class="fas fa-edit"></i> Edit
                </button>
                <button class="btn btn-danger delete-problem-btn">
                    <i class="fas fa-trash"></i> Delete
                </button>
            </div>
        </div>
    </template>
</div>

<script src="assets/js/admin.js"></script>
<script src="assets/js/theme.js"></script>
</body>
</html>
