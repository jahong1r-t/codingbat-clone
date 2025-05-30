/**
 * Problem Solving Page Handler
 */
document.addEventListener('DOMContentLoaded', () => {
  // Get current user
  const currentUser = StorageService.getCurrentUser();
  if (!currentUser) {
    window.location.href = 'index.html';
    return;
  }
  
  // Get problem ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  const problemId = urlParams.get('id');
  
  if (!problemId) {
    window.location.href = 'dashboard.html';
    return;
  }
  
  // Get problem
  const problem = StorageService.getProblemById(problemId);
  
  if (!problem) {
    window.location.href = 'dashboard.html';
    return;
  }
  
  // DOM elements
  const problemTitle = document.getElementById('problem-title');
  const problemDifficulty = document.getElementById('problem-difficulty');
  const problemDescription = document.getElementById('problem-description');
  const exampleTestCases = document.getElementById('example-test-cases');
  const codeEditor = document.getElementById('code-editor');
  const lineNumbers = document.getElementById('line-numbers');
  const runBtn = document.getElementById('run-btn');
  const resultsSummary = document.getElementById('results-summary');
  const testResults = document.getElementById('test-results');
  const editorTabs = document.querySelectorAll('.editor-tab');
  
  // Load problem data
  problemTitle.textContent = problem.title;
  problemDifficulty.textContent = problem.difficulty;
  problemDifficulty.classList.add(`difficulty-${problem.difficulty}`);
  problemDescription.innerHTML = problem.description;
  
  // Load example test cases (non-hidden only)
  const visibleTestCases = problem.testCases.filter(tc => !tc.hidden);
  
  visibleTestCases.forEach((testCase, index) => {
    const template = document.getElementById('test-case-template');
    const element = template.content.cloneNode(true);
    
    element.querySelector('.test-case-title').textContent = `Test Case #${index + 1}`;
    element.querySelector('.test-input pre').textContent = testCase.input;
    element.querySelector('.test-expected pre').textContent = testCase.output;
    
    exampleTestCases.appendChild(element);
  });
  
  // Load user code or template
  const userProgress = StorageService.getUserProgress(currentUser.username);
  const savedCode = userProgress[problemId]?.code || problem.template;
  codeEditor.value = savedCode;
  
  // Set up line numbers
  function updateLineNumbers() {
    const lines = codeEditor.value.split('\n').length;
    lineNumbers.innerHTML = Array.from({ length: lines }, (_, i) => i + 1).join('<br>');
  }
  
  updateLineNumbers();
  
  // Update line numbers on input
  codeEditor.addEventListener('input', () => {
    updateLineNumbers();
    
    // Save code as user types
    StorageService.updateUserProgress(currentUser.username, problemId, {
      code: codeEditor.value
    });
  });
  
  // Handle tab key in editor
  codeEditor.addEventListener('keydown', (e) => {
    if (e.key === 'Tab') {
      e.preventDefault();
      
      // Insert tab at cursor position
      const start = codeEditor.selectionStart;
      const end = codeEditor.selectionEnd;
      
      codeEditor.value = codeEditor.value.substring(0, start) + '    ' + codeEditor.value.substring(end);
      codeEditor.selectionStart = codeEditor.selectionEnd = start + 4;
      
      // Update line numbers
      updateLineNumbers();
    }
  });
  
  // Tab switching
  editorTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      // Update active tab
      editorTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      
      // Show corresponding container
      document.querySelectorAll('.editor-container').forEach(container => {
        container.classList.remove('active');
      });
      
      const containerId = `${tab.dataset.tab}-container`;
      document.getElementById(containerId).classList.add('active');
    });
  });
  
  // Run code and check test cases
  runBtn.addEventListener('click', () => {
    const userCode = codeEditor.value;
    const results = [];
    let passed = 0;
    let failed = 0;
    let error = 0;
    
    // Simple "simulation" - we're not actually running Java code
    // Instead, we're just checking if the code contains the expected output
    problem.testCases.forEach((testCase, index) => {
      let status = 'failed';
      let actualOutput = '';
      
      // Very simplistic code checking - in a real app, this would be much more sophisticated
      try {
        // Check if the code contains a return statement with the expected output
        // This is a very naive approach just for demonstration
        if (userCode.includes(`return "${testCase.output}"`) || 
            userCode.includes(`return '${testCase.output}'`) || 
            userCode.includes(`return ${testCase.output}`)) {
          status = 'passed';
          actualOutput = testCase.output;
          passed++;
        } else {
          // Simple pattern matching for different algorithms
          if (problem.title === 'Reverse a String') {
            // Check for common string reversal patterns
            if (userCode.includes('StringBuilder') && 
                userCode.includes('reverse()') && 
                userCode.includes('return') && 
                userCode.includes('toString()')) {
              status = 'passed';
              actualOutput = testCase.output;
              passed++;
            } else if (userCode.includes('char[]') && 
                       userCode.includes('for') && 
                       userCode.includes('length') && 
                       userCode.includes('return')) {
              status = 'passed';
              actualOutput = testCase.output;
              passed++;
            } else {
              status = 'failed';
              actualOutput = 'Wrong implementation';
              failed++;
            }
          } else if (problem.title === 'Fibonacci Number') {
            // Check for common fibonacci patterns
            if ((userCode.includes('if (n <= 1)') || userCode.includes('if(n<=1)')) && 
                userCode.includes('return n') &&
                userCode.includes('return fibonacci(n-1) + fibonacci(n-2)')) {
              status = 'passed';
              actualOutput = testCase.output;
              passed++;
            } else if (userCode.includes('int a = 0') && 
                       userCode.includes('int b = 1') && 
                       userCode.includes('for') && 
                       userCode.includes('return')) {
              status = 'passed';
              actualOutput = testCase.output;
              passed++;
            } else {
              status = 'failed';
              actualOutput = 'Wrong implementation';
              failed++;
            }
          } else {
            status = 'failed';
            actualOutput = 'Wrong output';
            failed++;
          }
        }
      } catch (e) {
        status = 'error';
        actualOutput = 'Runtime error';
        error++;
      }
      
      results.push({
        testCase,
        index,
        status,
        actualOutput
      });
    });
    
    // Update results
    resultsSummary.innerHTML = `
      <span class="status-passed">Passed: ${passed}</span>
      <span class="status-failed">Failed: ${failed}</span>
      <span class="status-error">Error: ${error}</span>
    `;
    
    // Clear previous results
    testResults.innerHTML = '';
    
    // Add result for each test case
    results.forEach(result => {
      const template = document.getElementById('test-result-template');
      const element = template.content.cloneNode(true);
      
      element.querySelector('.test-result-title').textContent = `Test Case #${result.index + 1}${result.testCase.hidden ? ' (Hidden)' : ''}`;
      
      const statusElement = element.querySelector('.test-result-status');
      statusElement.textContent = result.status.charAt(0).toUpperCase() + result.status.slice(1);
      statusElement.classList.add(`status-${result.status}`);
      
      element.querySelector('.test-input pre').textContent = result.testCase.input;
      element.querySelector('.test-expected pre').textContent = result.testCase.output;
      element.querySelector('.test-actual pre').textContent = result.actualOutput;
      
      testResults.appendChild(element);
    });
    
    // Switch to results tab
    editorTabs[1].click();
    
    // Update user progress
    const allPassed = passed === problem.testCases.length;
    
    StorageService.updateUserProgress(currentUser.username, problemId, {
      code: userCode,
      status: allPassed ? 'completed' : 'attempted',
      lastRun: new Date().toISOString(),
      testResults: results.map(r => ({
        index: r.index,
        status: r.status
      }))
    });
  });
});