<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>CodingBat - Problem</title>
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
            <a href="${pageContext.request.contextPath}/auth">
                <button id="login-btn" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>
            </a>
        </div>
    </nav>

    <main class="problem-container">
        <div class="problem-content">

            <!-- Problem Description -->
            <div class="problem-description-panel">
                <div class="problem-header">
                    <h2 id="problem-title">Fibonacci Number</h2>
                    <span id="problem-difficulty" class="difficulty-badge difficulty-medium">Medium</span>
                </div>
                <div class="problem-description" id="problem-description">
                    <p>The Fibonacci numbers, commonly denoted F(n), form a sequence such that each number is the sum of
                        the two preceding ones, starting from 0 and 1.</p>
                    <p>That is: F(0) = 0, F(1) = 1, and F(n) = F(n-1) + F(n-2) for n > 1.</p>
                    <p>Given n, calculate F(n).</p>
                    <p><strong>Example:</strong></p>
                    <pre>Input: n = 4
Output: 3
Explanation: F(4) = F(3) + F(2) = 2 + 1 = 3.</pre>
                </div>

                <!-- Example Test Cases -->
                <div class="test-cases-section">
                    <h3>Example Test Cases</h3>
                    <div class="test-cases" id="example-test-cases">

                        <!-- Test Case 1 -->
                        <div class="test-case">
                            <div class="test-case-header">
                                <span class="test-case-title">Test Case #1</span>
                            </div>
                            <div class="test-case-content">
                                <div class="test-input">
                                    <strong>Input:</strong>
                                    <pre class="code-block">4</pre>
                                </div>
                                <div class="test-expected">
                                    <strong>Expected Output:</strong>
                                    <pre class="code-block">3</pre>
                                </div>
                                <div class="test-explanation">
                                    <strong>Explanation:</strong>
                                    <pre class="code-block">F(4) = F(3) + F(2) = 2 + 1 = 3</pre>
                                </div>
                            </div>
                        </div>

                        <!-- Test Case 2 -->
                        <div class="test-case">
                            <div class="test-case-header">
                                <span class="test-case-title">Test Case #2</span>
                            </div>
                            <div class="test-case-content">
                                <div class="test-input">
                                    <strong>Input:</strong>
                                    <pre class="code-block">10</pre>
                                </div>
                                <div class="test-expected">
                                    <strong>Expected Output:</strong>
                                    <pre class="code-block">55</pre>
                                </div>
                            </div>
                        </div>

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
                        <textarea id="code-editor" class="code-editor">
public class Solution {
    public int fibonacci(int n) {
        // Write your code here
    }
}
            </textarea>
                    </div>
                </div>

                <!-- Test Results -->
                <div class="editor-container" id="results-container">
                    <div class="results-header">
                        <h3>Test Results</h3>
                        <div class="results-summary" id="results-summary">
                            <span class="status-passed">Passed: 1</span>
                            <span class="status-failed">Failed: 1</span>
                            <span class="status-error">Error: 0</span>
                        </div>
                    </div>

                    <div class="test-results" id="test-results">
                        <!-- Passed Case -->
                        <div class="test-result">
                            <div class="test-result-header">
                                <span class="test-result-title">Test Case #1</span>
                                <span class="test-result-status status-passed">Passed</span>
                            </div>
                            <div class="test-result-content">
                                <div class="test-input"><strong>Input:</strong>
                                    <pre class="code-block">4</pre>
                                </div>
                                <div class="test-expected"><strong>Expected Output:</strong>
                                    <pre class="code-block">3</pre>
                                </div>
                                <div class="test-actual"><strong>Your Output:</strong>
                                    <pre class="code-block">3</pre>
                                </div>
                            </div>
                        </div>

                        <!-- Failed Case -->
                        <div class="test-result">
                            <div class="test-result-header">
                                <span class="test-result-title">Test Case #2</span>
                                <span class="test-result-status status-failed">Failed</span>
                            </div>
                            <div class="test-result-content">
                                <div class="test-input"><strong>Input:</strong>
                                    <pre class="code-block">10</pre>
                                </div>
                                <div class="test-expected"><strong>Expected Output:</strong>
                                    <pre class="code-block">55</pre>
                                </div>
                                <div class="test-actual"><strong>Your Output:</strong>
                                    <pre class="code-block">Wrong output</pre>
                                </div>
                            </div>
                        </div>
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

<!-- Local Scripts -->
<script src="assets/js/problem.js"></script>
<script src="assets/js/theme.js"></script>

</body>
</html>
