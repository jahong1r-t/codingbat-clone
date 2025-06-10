<%--@elvariable id="problem" type="com.example.Problem"--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CodingBat - ${problem.title}</title>
    <link rel="icon" type="image/x-icon" href="assets/img/logo.png">

    <!-- Styles -->
    <link rel="stylesheet" href="assets/css/styles.css"/>
    <link rel="stylesheet" href="assets/css/problem.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/theme/dracula.min.css"/>

    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/clike/clike.min.js"></script>
</head>
<body>

<div class="app-container">
    <!-- Navbar -->
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

            <a href="${pageContext.request.contextPath}/">
                <button id="problems-link" class="btn btn-primary">
                    <i class="fas fa-list"></i> Problems
                </button>
            </a>

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
                            <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="dropdown-item-form">
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

    <main class="problem-container">
        <div class="problem-content">

            <!-- Problem Description -->
            <div class="problem-description-panel">
                <div class="problem-header">
                    <h2 id="problem-title"><c:out value="${problem.title}"/></h2>
                    <span id="problem-difficulty" class="difficulty-badge difficulty-${problem.difficulty.name().toLowerCase()}">
                        <c:out value="${problem.difficulty}"/>
                    </span>
                </div>
                <div class="problem-description" id="problem-description">
                    <p><c:out value="${problem.description}" escapeXml="false"/></p>
                </div>

                <!-- Example Test Cases -->
                <div class="test-cases-section">
                    <h3>Example Test Cases</h3>
                    <div class="test-cases" id="example-test-cases">
                        <c:forEach var="testCase" items="${problem.testCases}" varStatus="loop">
                            <div class="test-case">
                                <div class="test-case-header">
                                    <span class="test-case-title">Test Case #${loop.count}</span>
                                </div>
                                <div class="test-case-content">
                                    <div class="test-input">
                                        <strong>Input:</strong>
                                        <pre class="code-block"><c:out value="${testCase.input}"/></pre>
                                    </div>
                                    <div class="test-expected">
                                        <strong>Expected Output:</strong>
                                        <pre class="code-block"><c:out value="${testCase.expectedOutput}"/></pre>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Editor Panel -->
            <div class="editor-panel">
                <div class="editor-tabs">
                    <button class="editor-tab active" data-tab="editor">Code Editor</button>
                    <button class="editor-tab" data-tab="results">Test Results</button>
                </div>

                <!-- Code Editor -->
                <div class="editor-container active" id="editor-container">
                    <div class="editor-toolbar">
                        <span class="file-name">Solution.java</span>
                        <div class="button-group">
                            <button id="format-btn" class="btn btn-primary">
                                <i class="fas fa-magic"></i> Format
                            </button>
                            <button id="submit-btn" class="btn btn-primary">
                                <i class="fas fa-play"></i> Run Tests
                            </button>
                        </div>
                    </div>
                    <div class="code-editor-wrapper">
                        <div class="line-numbers" id="line-numbers">1<br>2<br>3<br>4</div>
                        <label for="code-editor"></label>
                        <textarea id="code-editor" class="code-editor"><c:out value="${problem.codeTemplate}"/></textarea>
                    </div>
                </div>

                <!-- Test Results -->
                <div class="editor-container" id="results-container">
                    <div class="results-header">
                        <h3>Test Results</h3>
                        <div class="results-summary" id="results-summary">
                            <!-- Test natijalari dinamik ravishda JavaScript yoki boshqa servlet orqali yangilanadi -->
                            <span class="status-passed">Passed: 0</span>
                            <span class="status-failed">Failed: 0</span>
                            <span class="status-error">Error: 0</span>
                        </div>
                    </div>
                    <div class="test-results" id="test-results">
                        <!-- Test natijalari JavaScript yoki backenddan keladi -->
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Templates -->
<template id="test-case-template">
    <div class="test-case">
        <div class="test-case-header"><span class="test-case-title">Test Case #1</span></div>
        <div class="test-case-content">
            <div class="test-input"><strong>Input:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-expected"><strong>Expected Output:</strong>
                <pre class="code-block"></pre>
            </div>
        </div>
    </div>
</template>

<template id="test-result-template">
    <div class="test-result">
        <div class="test-result-header">
            <span class="test-result-title">Test Case #1</span>
            <span class="test-result-status"></span>
        </div>
        <div class="test-result-content">
            <div class="test-input"><strong>Input:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-expected"><strong>Expected Output:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-actual"><strong>Your Output:</strong>
                <pre class="code-block"></pre>
            </div>
        </div>
    </div>
</template>

<script src="assets/js/problem.js"></script>
<script src="assets/js/theme.js"></script>

</body>
</html>
