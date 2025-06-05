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
            <a href="${pageContext.request.contextPath}/auth?tab=signin">
                <button id="sign-in-btn" class="btn btn-primary">
                    Sign In
                </button>
            </a>

            <a href="${pageContext.request.contextPath}/auth?tab=signup">
                <button id="sign-up-btn" class="btn btn-primary">
                    Sign Up
                </button>
            </a>
        </div>
    </nav>

    <main class="dashboard-container">
        <header class="dashboard-header">
            <h2>Java Coding</h2>
            <div class="search-container">
                <label for="search-input"></label>

                <input type="text" id="search-input" placeholder="Search problems...">
                <i class="fas fa-search"></i>
            </div>
        </header>

        <div class="filters">
            <a href="${pageContext.request.contextPath}/">
                <button class="filter-btn active" data-filter="all">All</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=easy">
                <button class="filter-btn" data-filter="easy">Easy</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=medium">
                <button class="filter-btn" data-filter="medium">Medium</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=hard">
                <button class="filter-btn" data-filter="hard">Hard</button>
            </a>
            <a href="${pageContext.request.contextPath}/?filter=completed">
                <button class="filter-btn" data-filter="completed">Completed</button>
            </a>
        </div>

        <div class="problem-list" id="problem-list">
            <div class="problem-card">
                <div class="problem-status">
                    <span class="status-icon"></span>
                </div>
                <div class="problem-info">
                    <h3 class="problem-title">Two Sum</h3>
                    <div class="problem-meta">
                        <span class="problem-difficulty difficulty-easy">Easy</span>
                        <span class="problem-completion">Solved</span>
                    </div>
                </div>
                <div class="problem-action">
                    <a href="problem">
                        <button class="btn btn-primary solve-btn">Solve Again</button>
                    </a>
                </div>
            </div>

            <div class="problem-card">
                <div class="problem-status">
                    <span class="status-icon"></span>
                </div>
                <div class="problem-info">
                    <h3 class="problem-title">Longest Substring</h3>
                    <div class="problem-meta">
                        <span class="problem-difficulty difficulty-medium">Medium</span>
                        <span class="problem-completion">In Progress</span>
                    </div>
                </div>
                <div class="problem-action">
                    <button class="btn btn-primary solve-btn">Continue</button>
                </div>
            </div>

            <div class="problem-card">
                <div class="problem-status">
                    <span class="status-icon"></span>
                </div>
                <div class="problem-info">
                    <h3 class="problem-title">Container With Most Water</h3>
                    <div class="problem-meta">
                        <span class="problem-difficulty difficulty-hard">Hard</span>
                        <span class="problem-completion">Not Solved</span>
                    </div>
                </div>
                <div class="problem-action">
                    <button class="btn btn-primary solve-btn">Solve</button>
                </div>
            </div>

        </div>
    </main>
</div>

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

<script src="${pageContext.request.contextPath}/assets/js/theme.js"></script>

</body>
</html>
