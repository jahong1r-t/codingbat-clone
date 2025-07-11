<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>CodingBat</title>

    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

    <!-- Main Dashboard -->
    <main class="dashboard-container">
        <header class="dashboard-header">
            <h2>Java Coding</h2>
            <div class="search-container">
                <label for="search-input"></label>
                <input type="text" id="search-input" placeholder="Search problems...">
                <i class="fas fa-search"></i>
            </div>
        </header>

        <!-- Filters -->
        <div class="filters">
            <a href="${pageContext.request.contextPath}/">
                <button class="filter-btn ${filter == null ?'active':''}" data-filter="all">All</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=easy">
                <button class="filter-btn ${filter == "easy" ?'active':''}" data-filter="easy">Easy</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=medium">
                <button class="filter-btn ${filter == "medium" ?'active':''}" data-filter="medium">Medium</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=hard">
                <button class="filter-btn ${filter == "hard" ?'active':''}" data-filter="hard">Hard</button>
            </a>
        </div>

        <!-- Problem List -->
        <div class="problem-list" id="problem-list">
            <%--@elvariable id="problems" type="java.util.List"--%>
            <c:forEach items="${problems}" var="p">
                <div class="problem-card">
                    <div class="problem-status">
                        <span class="status-icon"></span>
                    </div>
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
                            <span class="problem-completion">Not Solved</span>
                        </div>
                    </div>
                    <div class="problem-action">
                        <a href="${pageContext.request.contextPath}/problem?id=${p.id}">
                            <button class="btn btn-primary solve-btn">Solve</button>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<!-- Template for JS rendering -->
<template id="problem-card-template">
    <div class="problem-card">
        <div class="problem-status">
            <span class="status-icon"></span>
        </div>
        <div class="problem-info">
            <h3 class="problem-title"></h3>
            <div class="problem-meta">
                <span class="problem-difficulty"></span>
                <span class="problem-completion"></span>
            </div>
        </div>
        <div class="problem-action">
            <button class="btn btn-primary solve-btn">Solve</button>
        </div>
    </div>
</template>

<div class="pagination">
    <!-- Previous Button -->
    <c:choose>
        <c:when test="${previous > 0}">
            <a href="?filter=${filter}&page=${previous}" class="pagination-btn">
                <i class="fas fa-chevron-left"></i> Prev
            </a>
        </c:when>
        <c:otherwise>
            <span class="pagination-btn disabled">
                <i class="fas fa-chevron-left"></i> Prev
            </span>
        </c:otherwise>
    </c:choose>

    <!-- Page Numbers -->
    <c:set var="totalPages" value="${totalPages}"/>
    <c:set var="currentPage" value="${currentPage}"/>
    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="?filter=${filter}&page=${i}" class="pagination-btn ${i == currentPage ? 'active' : ''}">
                ${i}
        </a>
    </c:forEach>

    <!-- Next Button -->
    <c:choose>
        <c:when test="${next <= totalPages}">
            <a href="?filter=${filter}&page=${next}" class="pagination-btn">
                Next <i class="fas fa-chevron-right"></i>
            </a>
        </c:when>
        <c:otherwise>
            <span class="pagination-btn disabled">
                  Next<i class="fas fa-chevron-right"></i>
            </span>
        </c:otherwise>
    </c:choose>
</div>

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>

</body>
</html>
