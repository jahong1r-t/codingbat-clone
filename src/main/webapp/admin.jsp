<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>CodingBat - Admin Panel</title>
    <link rel="icon" type="image/x-icon" href="assets/img/logo.png">
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
                <img id="logo-img" src="${pageContext.request.contextPath}/assets/img/logo-black.png" width="150px"
                     alt="logo">
            </a>
        </div>
        <div class="navbar-menu">
            <div class="theme-toggle">
                <i class="fas fa-moon"></i>
            </div>
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

    <main class="admin-container">
        <header class="admin-header">
            <h2>Admin Panel</h2>
            <a href="${pageContext.request.contextPath}/add">
                <button class="btn btn-primary">
                    <i class="fas fa-plus"></i> Add New Problem
                </button>
            </a>
        </header>

        <div class="statistics-grid">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <div class="stat-content">
                    <h3>Total Users</h3>
                    <p id="total-users"><c:out value="${stats.totalUsers}"/></p>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-code"></i>
                <div class="stat-content">
                    <h3>Total Problems</h3>
                    <p id="total-problems"><c:out value="${stats.totalProblems}"/></p>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-clock"></i>
                <div class="stat-content">
                    <h3>Latest Problem</h3>
                    <p id="latest-problem"><c:out value="${stats.latestProblem}"/></p>
                    <small id="latest-problem-date"></small>
                </div>
            </div>
            <div class="stat-card">
                <i class="fas fa-star"></i>
                <div class="stat-content">
                    <h3>Most Solved</h3>
                    <p id="most-solved"><c:out value="${stats.mostSolved}"/></p>
                    <small id="most-solved-count"></small>
                </div>
            </div>
        </div>

        <div class="problem-list" id="problem-list">
            <c:forEach items="${page.content}" var="p">
                <div class="problem-card">
                    <div class="problem-info">
                        <h3 class="problem-title">${p.title}</h3>
                        <div class="problem-meta">
                            <span class="problem-difficulty
                                ${p.difficulty == 'EASY' ? 'difficulty-easy' :
                                  p.difficulty == 'MEDIUM' ? 'difficulty-medium' :
                                  'difficulty-hard'}">
                                    ${p.difficulty == 'EASY' ? 'Easy' :
                                            p.difficulty == 'MEDIUM' ? 'Medium' :
                                                    'Hard'}
                            </span>
                            <span class="problem-completion">${p.testCaseCount} test cases</span>
                        </div>
                    </div>
                    <div class="problem-actions">

                        <a style="text-decoration: none" href="${pageContext.request.contextPath}/delete?id=${p.id}">
                            <button class="btn btn-outline delete-problem-btn">
                                <i class="fas fa-trash"></i>
                            </button>
                        </a>

                        <a style="text-decoration: none" href="${pageContext.request.contextPath}/problem?id=${p.id}">
                            <button class="btn btn-outline delete-problem-btn">
                                <i class="fas fa-eye"></i>
                            </button>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>

    </main>

    <div class="pagination">
        <c:choose>
            <c:when test="${page.previousPage > 0}">
                <a href="?filter=${page.filter}&page=${page.previousPage}" class="pagination-btn">
                    <i class="fas fa-chevron-left"></i> Prev
                </a>
            </c:when>
            <c:otherwise>
            <span class="pagination-btn disabled">
                <i class="fas fa-chevron-left"></i> Prev
            </span>
            </c:otherwise>
        </c:choose>

        <c:forEach begin="1" end="${page.totalPages}" var="i">
            <a href="?filter=${page.filter}&page=${i}"
               class="pagination-btn ${i == page.currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:choose>
            <c:when test="${page.nextPage <= page.totalPages}">
                <a href="?filter=${page.filter}&page=${page.nextPage}" class="pagination-btn">
                    Next <i class="fas fa-chevron-right"></i>
                </a>
            </c:when>
            <c:otherwise>
            <span class="pagination-btn disabled">
                Next <i class="fas fa-chevron-right"></i>
            </span>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="assets/js/admin.js"></script>
<script src="assets/js/theme.js"></script>
</body>
</html>