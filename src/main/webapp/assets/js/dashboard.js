/**
 * Dashboard Handler
 */
document.addEventListener('DOMContentLoaded', () => {
  // Get current user
  const currentUser = StorageService.getCurrentUser();
  if (!currentUser) {
    window.location.href = 'index.html';
    return;
  }
  
  // DOM elements
  const problemList = document.getElementById('problem-list');
  const searchInput = document.getElementById('search-input');
  const filterButtons = document.querySelectorAll('.filter-btn');
  const totalUsersElement = document.getElementById('total-users');
  const totalProblemsElement = document.getElementById('total-problems');
  const latestProblemElement = document.getElementById('latest-problem');
  const latestProblemDateElement = document.getElementById('latest-problem-date');
  const mostSolvedElement = document.getElementById('most-solved');
  const mostSolvedCountElement = document.getElementById('most-solved-count');
  
  // Current filter
  let currentFilter = 'all';

  /**
   * Load statistics
   */
  function loadStatistics() {
    const users = StorageService.getUsers();
    const problems = StorageService.getProblems();
    const allProgress = StorageService.getAllProgress();

    // Total users
    totalUsersElement.textContent = users.length;

    // Total problems
    totalProblemsElement.textContent = problems.length;

    // Latest problem
    if (problems.length > 0) {
      const latestProblem = problems.reduce((latest, current) => {
        const currentDate = new Date(current.dateAdded || 0);
        const latestDate = new Date(latest.dateAdded || 0);
        return currentDate > latestDate ? current : latest;
      });

      latestProblemElement.textContent = latestProblem.title;
      if (latestProblem.dateAdded) {
        const date = new Date(latestProblem.dateAdded);
        latestProblemDateElement.textContent = date.toLocaleDateString();
      }
    }

    // Most solved problem
    const problemSolveCount = {};
    Object.values(allProgress).forEach(userProgress => {
      Object.entries(userProgress).forEach(([problemId, progress]) => {
        if (progress.status === 'completed') {
          problemSolveCount[problemId] = (problemSolveCount[problemId] || 0) + 1;
        }
      });
    });

    if (Object.keys(problemSolveCount).length > 0) {
      const mostSolvedId = Object.entries(problemSolveCount).reduce((a, b) => 
        b[1] > a[1] ? b : a
      )[0];

      const mostSolvedProblem = problems.find(p => p.id === mostSolvedId);
      if (mostSolvedProblem) {
        mostSolvedElement.textContent = mostSolvedProblem.title;
        mostSolvedCountElement.textContent = 
          `${problemSolveCount[mostSolvedId]} ${
            problemSolveCount[mostSolvedId] === 1 ? 'solution' : 'solutions'
          }`;
      }
    }
  }
  
  /**
   * Load and display problems
   */
  function loadProblems() {
    // Get all problems
    const problems = StorageService.getProblems();
    
    // Get user progress
    const userProgress = StorageService.getUserProgress(currentUser.username);
    
    // Clear problem list
    problemList.innerHTML = '';
    
    // Filter problems based on search and filter
    const searchTerm = searchInput.value.toLowerCase();
    let filteredProblems = problems.filter(problem => 
      problem.title.toLowerCase().includes(searchTerm)
    );
    
    // Apply category filter
    if (currentFilter !== 'all') {
      if (currentFilter === 'completed') {
        filteredProblems = filteredProblems.filter(problem => 
          userProgress[problem.id] && userProgress[problem.id].status === 'completed'
        );
      } else {
        filteredProblems = filteredProblems.filter(problem => 
          problem.difficulty === currentFilter
        );
      }
    }
    
    // Create problem cards
    if (filteredProblems.length === 0) {
      problemList.innerHTML = `
        <div class="text-center" style="grid-column: 1 / -1; padding: var(--space-3);">
          <p>No problems found</p>
        </div>
      `;
      return;
    }
    
    filteredProblems.forEach(problem => {
      // Clone template
      const template = document.getElementById('problem-card-template');
      const card = template.content.cloneNode(true);
      
      // Get progress for this problem
      const progress = userProgress[problem.id] || {};
      
      // Fill in problem data
      card.querySelector('.problem-title').textContent = problem.title;
      
      // Set difficulty
      const difficultyElement = card.querySelector('.problem-difficulty');
      difficultyElement.textContent = problem.difficulty;
      difficultyElement.classList.add(`difficulty-${problem.difficulty}`);
      
      // Set completion status
      const statusIcon = card.querySelector('.status-icon');
      const completionText = card.querySelector('.problem-completion');
      
      if (progress.status === 'completed') {
        statusIcon.classList.add('status-completed');
        completionText.textContent = 'Completed';
      } else if (progress.lastUpdated) {
        completionText.textContent = 'In progress';
      } else {
        completionText.textContent = 'Not started';
      }
      
      // Set up solve button
      const solveBtn = card.querySelector('.solve-btn');
      solveBtn.addEventListener('click', () => {
        window.location.href = `problem.html?id=${problem.id}`;
      });
      
      // Add card to list
      problemList.appendChild(card);
    });
  }
  
  // Set up search input
  searchInput.addEventListener('input', loadProblems);
  
  // Set up filter buttons
  filterButtons.forEach(button => {
    button.addEventListener('click', () => {
      // Update active button
      filterButtons.forEach(btn => btn.classList.remove('active'));
      button.classList.add('active');
      
      // Update current filter
      currentFilter = button.dataset.filter;
      
      // Reload problems
      loadProblems();
    });
  });
  
  // Initial load
  loadStatistics();
  loadProblems();
});