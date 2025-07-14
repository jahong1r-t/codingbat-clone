<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Problem - CodeChallenger</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/forms.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="app-container">
    <nav class="navbar">
        <div class="navbar-brand">
            <a href="${pageContext.request.contextPath}/">
                <img id="logo-img" src="${pageContext.request.contextPath}/assets/img/logo-black.png" width="150px"
                     alt="logo">
            </a>
        </div>

        <div class="navbar-menu">
            <div class="theme-toggle">
                <i class="fas fa-moon"></i>
            </div>

            <c:choose>
                <c:when test="${role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin">
                        <button class="btn btn-primary">
                            <i class="fas fa-list"></i> Problems
                        </button>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/">
                        <button class="btn btn-primary">
                            <i class="fas fa-list"></i> Problems
                        </button>
                    </a>
                </c:otherwise>
            </c:choose>


            <c:choose>
                <c:when test="${sessionScope.is_authenticated == true}">
                    <div class="profile-dropdown">
                        <button class="btn btn-primary profile-btn" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-user"></i>
                            <span>Profile</span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="dropdown-menu">
                            <a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
                                <i class="fas fa-user-circle"></i> Profile
                            </a>
                            <form action="${pageContext.request.contextPath}/auth/logout" method="post"
                                  class="dropdown-item-form">
                                <button type="submit" class="dropdown-item logout-btn">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </button>
                            </form>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth?tab=signin">
                        <button id="sign-in-btn" class="btn btn-primary">Sign In</button>
                    </a>
                    <a href="${pageContext.request.contextPath}/auth?tab=signup">
                        <button id="sign-up-btn" class="btn btn-primary">Sign Up</button>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>

    <main class="problem-form-container">

        <form id="problem-form" class="problem-form">
            <div class="form-layout">
                <!-- Left Column: Problem Details -->
                <div class="left-column">
                    <div class="form-section">
                        <h3><i class="fas fa-info-circle"></i> Basic Information</h3>

                        <div class="form-group">
                            <label for="problem-title">Problem Title *</label>
                            <input type="text" id="problem-title" name="title" required
                                   placeholder="e.g., Two Sum, Binary Search">
                        </div>

                        <div class="form-group">
                            <label for="problem-difficulty">Difficulty *</label>
                            <select id="problem-difficulty" name="difficulty" required>
                                <option value="">Select difficulty</option>
                                <option value="easy">Easy</option>
                                <option value="medium">Medium</option>
                                <option value="hard">Hard</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-file-alt"></i> Problem Description</h3>

                        <div class="form-group">
                            <label for="problem-description">Description *</label>
                            <textarea id="problem-description" name="description" rows="12" required
                                      placeholder="Write a detailed description of the problem. Include examples, constraints, and any special requirements."></textarea>
                        </div>
                    </div>

                    <div class="form-section">
                        <h3><i class="fas fa-code"></i> Code Template</h3>

                        <div class="form-group">
                            <label for="problem-template">Java Code Template *</label>
                            <textarea id="problem-template" name="template" rows="12" required class="code-textarea"
                                      placeholder="public class Solution {
    public int solve(int[] nums) {
        // Write your code here

    }
}"></textarea>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Test Cases -->
                <div class="right-column">
                    <div class="form-section test-cases-section">
                        <div class="section-header">
                            <h3><i class="fas fa-vial"></i> Test Cases</h3>
                            <button type="button" id="add-test-case" class="btn btn-secondary">
                                <i class="fas fa-plus"></i> Add Test Case
                            </button>
                        </div>

                        <div id="test-cases-container">
                            <!-- Test cases will be added here -->
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Create Problem
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </main>
</div>

<template id="test-case-template">
    <div class="test-case-item">
        <div class="test-case-header">
            <h4>Test Case</h4>
            <div class="test-case-controls">
                <label class="checkbox-label">
                    <input type="checkbox" class="hidden-checkbox" name="hidden">
                    <span class="checkbox-text">Hidden</span>
                </label>
                <button type="button" class="btn btn-danger btn-sm remove-test-case">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        </div>

        <div class="test-case-content">
            <div class="form-row">
                <div class="form-group">
                    <label>Input *</label>
                    <textarea class="test-input" name="input" rows="3" required
                              placeholder="Enter the input for this test case"></textarea>
                </div>

                <div class="form-group">
                    <label>Expected Output *</label>
                    <textarea class="test-output" name="expectedOutput" rows="3" required
                              placeholder="Enter the expected output"></textarea>
                </div>
            </div>
        </div>
    </div>
</template>


<script src="assets/js/form.js"></script>
<script src="assets/js/theme.js"></script>
</body>
</html>