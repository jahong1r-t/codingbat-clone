<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="cite" uri="http://java.sun.com/jsp/jstl/core" %>
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

            <c:choose>
                <c:when test="${sessionScope.role eq 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin">
                        <button id="problems-link" class="btn btn-primary">
                            <i class="fas fa-list"></i> Problems
                        </button>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/">
                        <button id="problems-link" class="btn btn-primary">
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

    <main style="margin-top: 10px" class="problem-container">
        <div class="problem-content">

            <!-- Problem Description -->
            <div class="problem-description-panel">
                <div class="problem-header">
                    <h2 id="problem-title"><c:out value="${problem.title}"/></h2>

                    <span id="problem-difficulty" class="difficulty-badge
                                    ${problem.difficulty == 'EASY' ? 'difficulty-easy' :
                                      problem.difficulty == 'MEDIUM' ? 'difficulty-medium' :
                                      'difficulty-hard'}">
                        ${problem.difficulty == 'EASY' ? 'Easy' :
                                problem.difficulty == 'MEDIUM' ? 'Medium' :
                                        'Hard'}
                    </span>

                </div>
                <div class="problem-description" id="problem-description">
                    <p><c:out value="${problem.description}"/></p>
                </div>

                <!-- Example Test Cases -->
                <div class="test-cases-section">
                    <h3>Example Test Cases</h3>
                    <div class="test-cases" id="example-test-cases">
                        <c:forEach var="testCase" items="${problem.testCases}" varStatus="loop">
                            <div class="test-case">
                                <div class="test-case-header">
                                    <span class="test-case-title">Test Case ${loop.count}</span>
                                </div>
                                <div class="test-case-content">
                                    <div class="test-input">
                                        <strong>Input:</strong>
                                        <pre class="code-block"><c:out value="${testCase.input}"/></pre>
                                    </div>
                                    <div class="test-expected">
                                        <strong>Expected Output:</strong>
                                        <pre class="code-block"><c:out value="${testCase.output}"/></pre>
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
                        <span class="file-name">Java</span>
                        <div class="button-group">
                            <form action="${pageContext.request.contextPath}/format" method="POST">
                                <input type="hidden" id="hidden-code-format" name="code">
                                <input type="hidden" value="${problem.id}" name="id">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-magic"></i> Format
                                </button>
                            </form>

                            <form action="${pageContext.request.contextPath}/problem/run" method="POST">
                                <input type="hidden" id="hidden-code-run" name="code">
                                <input type="hidden" value="${problem.id}" name="id">
                                <button class="btn btn-primary">
                                    <i class="fas fa-play"></i> Run
                                </button>
                            </form>

                        </div>
                    </div>


                    <c:set var="ca" value="${sessionScope.cache[problem.id.toString()]}"/>

                    <div class="code-editor-wrapper">
                        <div class="line-numbers" id="line-numbers">1<br>2<br>3<br>4</div>
                        <input type="hidden" id="problem-id" value="${problem.id}"/>
                        <label for="code-editor"></label>
                        <textarea id="code-editor" name="code"
                                  class="code-editor"><c:out
                                value="${ca.code != null ? ca.code : problem.codeTemplate}"/></textarea>


                        <%--                        <textarea id="code-editor" name="code"--%>
                        <%--                                  class="code-editor"><c:out--%>
                        <%--                                value="${f_code != null ? f_code : sessionScope.results.code==null ?--%>
                        <%--                                 problem.codeTemplate : sessionScope.cache[p.id.toString()]}"/></textarea>--%>
                    </div>
                </div>

                <!-- Test Results -->
                <div class="editor-container" id="results-container">
                    <div class="results-header">
                        <h3>Test Results</h3>
                        <div class="results-summary" id="results-summary">
                            <span class="status-passed">${sessionScope.results.passed} Passed</span>
                            <span class="status-error">${sessionScope.results.failed} Failed</span>
                            <span class="status-failed">${sessionScope.results.error} Error</span>
                        </div>
                    </div>

                    <div class="test-results" id="test-results">
                        <c:forEach items="${sessionScope.results.details}" var="d" varStatus="loop">
                            <div class="test-result">
                                <div class="test-result-header">
                                    <span class="test-result-title">Test Case ${loop.index + 1}</span>
                                    <span class="test-result-status"></span>
                                </div>
                                <div class="test-result-content">
                                    <div class="test-input"><strong>Input:</strong>
                                        <pre class="code-block">${d.input}</pre>
                                    </div>
                                    <div class="test-expected"><strong>Expected Output:</strong>
                                        <pre class="code-block">${d.output}</pre>
                                    </div>
                                    <div class="test-actual"><strong>Your Output:</strong>
                                        <pre class="code-block">${d.yourOutput}</pre>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.results}">
            <c:remove var="results" scope="session"/>
        </c:if>

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
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/clike/clike.min.js"></script>
</body>
</html>
