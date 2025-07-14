<%--@elvariable id="filter" type="uz.codingbat.codingbatclone"--%>
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
                        <button class="btn btn-primary profile-btn">
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
                        <button class="btn btn-primary">Sign In</button>
                    </a>
                    <a href="${pageContext.request.contextPath}/auth?tab=signup">
                        <button class="btn btn-primary">Sign Up</button>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </nav>
    <!-- Dashboard -->
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
                <button class="filter-btn ${page.filter == null ? 'active' : ''}">All</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=easy">
                <button class="filter-btn ${page.filter == 'easy' ? 'active' : ''}">Easy</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=medium">
                <button class="filter-btn ${page.filter == 'medium' ? 'active' : ''}">Medium</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=hard">
                <button class="filter-btn ${page.filter == 'hard' ? 'active' : ''}">Hard</button>
            </a>
        </div>


        <div>
            <c:out value="${sessionScope.cache}"/>
        </div>

        <!-- Problems List -->
        <div class="problem-list" id="problem-list">
            <c:forEach items="${page.content}" var="p">
                <c:set var="problemIdStr" value="${p.id.toString()}"/>
                <c:set var="cache" value="${sessionScope.cache[problemIdStr]}"/>

                <div class="problem-card">
                    <div class="problem-status">
                        <c:choose>
                            <c:when test="${sessionScope.is_authenticated == true}">
                                <c:set var="statusClass" value="status-default"/>
                                <c:if test="${p.status == 'SOLVED'}"><c:set var="statusClass"
                                                                            value="status-completed"/></c:if>
                                <c:if test="${p.status == 'OPENED'}"><c:set var="statusClass"
                                                                            value="status-warning"/></c:if>
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusClass" value="status-default"/>
                                <c:if test="${cache != null && cache.status eq 'SOLVED'}"><c:set var="statusClass"
                                                                                                 value="status-completed"/></c:if>
                                <c:if test="${cache != null && cache.status eq 'OPENED'}"><c:set var="statusClass"
                                                                                                 value="status-warning"/></c:if>
                            </c:otherwise>
                        </c:choose>

                        <span class="status-icon  ${statusClass}"></span>
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

                            <span class="problem-completion">
                                <c:choose>
                                    <c:when test="${sessionScope.is_authenticated == true}">
                                        <c:choose>
                                            <c:when test="${p.status == 'SOLVED'}">Completed</c:when>
                                            <c:when test="${p.status == 'OPENED'}">Continue</c:when>
                                            <c:otherwise>Solve</c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:choose>
                                            <c:when test="${cache != null && cache.status eq 'SOLVED'}">Completed</c:when>
                                            <c:when test="${cache != null && cache.status eq 'OPENED'}">Continue</c:when>
                                            <c:otherwise>Solve</c:otherwise>
                                        </c:choose>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="problem-action">
                        <a href="${pageContext.request.contextPath}/problem?id=${p.id}">
                            <c:choose>
                                <c:when test="${sessionScope.is_authenticated == true}">
                                    <c:choose>
                                        <c:when test="${p.status == 'SOLVED'}">
                                            <button class="btn btn-primary solve-btn">Completed</button>
                                        </c:when>
                                        <c:when test="${p.status == 'OPENED'}">
                                            <button class="btn btn-primary solve-btn">Continue</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary solve-btn">Solve</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${cache != null && cache.status eq 'SOLVED'}">
                                            <button class="btn btn-primary solve-btn">Completed</button>
                                        </c:when>
                                        <c:when test="${cache != null && cache.status eq 'OPENED'}">
                                            <button class="btn btn-primary solve-btn">Continue</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-primary solve-btn">Solve</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </a>

                    </div>
                </div>
            </c:forEach>
        </div>
    </main>
</div>

<!-- Pagination -->
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

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>
</body>
</html>
