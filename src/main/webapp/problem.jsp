<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/problem.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.css">
    <link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.7.2/css/all.css">
</head>
<body>
<div class="app-container">
    <nav class="navbar">
        <div class="navbar-brand">
            <i class="fas fa-code"></i>
            <h1>CodeChallenger</h1>
        </div>
        <div class="navbar-menu">
            <div class="theme-toggle">
                <i class="fas fa-moon"></i>
            </div>
            <button id="problems-link" class="btn btn-outline">
                <i class="fas fa-list"></i> Problems
            </button>
            <button id="logout-btn" class="btn btn-outline">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </div>
    </nav>

    <main class="problem-container">
        <div class="problem-content">
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
                    <p>Input: n = 4</p>
                    <p>Output: 3</p>
                    <p>Explanation: F(4) = F(3) + F(2) = 2 + 1 = 3.</p>
                </div>
                <div class="test-cases-section">
                    <h3>Example Test Cases</h3>
                    <div class="test-cases" id="example-test-cases">
                        <div class="test-case">
                            <div class="test-case-header">
                                <span class="test-case-title">Test Case #1</span>
                            </div>
                            <div class="test-case-content">
                                <div class="test-input">
                                    <strong>Input:</strong>
                                    <pre class="code-block">n = 4</pre>
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
                        <div class="test-case">
                            <div class="test-case-header">
                                <span class="test-case-title">Test Case #2</span>
                            </div>
                            <div class="test-case-content">
                                <div class="test-input">
                                    <strong>Input:</strong>
                                    <pre class="code-block">n = 0</pre>
                                </div>
                                <div class="test-expected">
                                    <strong>Expected Output:</strong>
                                    <pre class="code-block">0</pre>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="editor-panel">
                <div class="editor-tabs">
                    <button class="editor-tab active" data-tab="editor">Code Editor</button>
                    <button class="editor-tab" data-tab="results">Test Results</button>
                </div>

                <div class="editor-container active" id="editor-container">
                    <div class="editor-toolbar">
                        <span class="file-name">Solution.java</span>
                        <div class="button-group">
                            <button id="format-btn" class="btn btn-primary">
                                <i class="fa-solid fa-chart-simple-horizontal"></i> Format
                            </button>
                            <button id="run-btn" class="btn btn-primary">
                                <i class="fas fa-play"></i> Submit
                            </button>
                        </div>
                    </div>
                    <div class="code-editor-wrapper">
                        <div class="line-numbers" id="line-numbers">1</div>
                        <div id="code-editor" class="code-editor"></div>
                    </div>
                </div>

                <div class="editor-container" id="results-container">
                    <div class="results-header">
                        <h3>Test Results</h3>
                        <div class="results-summary" id="results-summary">
                            <!-- Test results summary will be inserted here -->
                        </div>
                    </div>
                    <div class="test-results" id="test-results">
                        <!-- Test results will be inserted here -->
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<template id="test-case-template">
    <div class="test-case">
        <div class="test-case-header">
            <span class="test-case-title">Test Case #1</span>
        </div>
        <div class="test-case-content">
            <div class="test-input">
                <strong>Input:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-expected">
                <strong>Expected Output:</strong>
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
            <div class="test-input">
                <strong>Input:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-expected">
                <strong>Expected Output:</strong>
                <pre class="code-block"></pre>
            </div>
            <div class="test-actual">
                <strong>Your Output:</strong>
                <pre class="code-block"></pre>
            </div>
        </div>
    </div>
</template>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const editorElement = document.getElementById('code-editor');
        if (!editorElement) {
            console.error('Code editor element not found.');
            return;
        }

        const codeEditor = CodeMirror(editorElement, {
            mode: 'text/x-java',
            theme: 'dracula',
            lineNumbers: false,
            indentUnit: 4,
            indentWithTabs: false,
            autoCloseBrackets: true,
            matchBrackets: true,
            extraKeys: {
                'Tab': (cm) => cm.execCommand('indentMore'),
                'Shift-Tab': (cm) => cm.execCommand('indentLess'),
                'Ctrl-Alt-L': (cm) => cm.execCommand('indentAuto')
            },
            value: 'public class Solution {\n    public int fib(int n) {\n        \n    }\n}'
        });

        codeEditor.setSize('100%', '100%');
        editorElement.style.zIndex = '10';

        const tabs = document.querySelectorAll('.editor-tab');
        const containers = document.querySelectorAll('.editor-container');

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                containers.forEach(c => c.classList.remove('active'));

                tab.classList.add('active');
                const targetContainer = document.getElementById(`${tab.dataset.tab}-container`);
                targetContainer.classList.add('active');
            });
        });

        // Format tugmasi
        const formatBtn = document.getElementById('format-btn');
        formatBtn.addEventListener('click', () => {
            codeEditor.execCommand('indentAuto');
            updateLineNumbers();
        });

        function updateLineNumbers() {
            const lines = codeEditor.lineCount();
            const lineNumbers = document.getElementById('line-numbers');
            lineNumbers.innerHTML = Array.from({length: lines}, (_, i) => i + 1).join('\n');
            lineNumbers.style.height = `${codeEditor.getWrapperElement().offsetHeight}px`;
        }

        codeEditor.on('scroll', () => {
            const scrollInfo = codeEditor.getScrollInfo();
            document.getElementById('line-numbers').scrollTop = scrollInfo.top;
        });

        codeEditor.on('change', () => {
            updateLineNumbers();
        });

        updateLineNumbers();

        const runBtn = document.getElementById('run-btn');
        runBtn.addEventListener('click', () => {
            const code = codeEditor.getValue();
            console.log('Running tests with code:', code);
        });
    });
</script>

<script src="assets/js/problem.js"></script>
<script src="assets/js/theme.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/6.65.7/mode/clike/clike.min.js"></script>
</body>
</html>
