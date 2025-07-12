<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - CodeChallenger</title>
    <link rel="stylesheet" href="assets/css/styles.css">
    <link rel="stylesheet" href="assets/css/profile.css">
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
                <c:when test="${user.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin">
                        <button class="btn btn-primary">
                            <i class="fas fa-list"></i> Problems
                        </button>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/">
                        <button class="btn btn-primary">
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

    <!-- Temporary debug output -->

    <main class="profile-container">
        <div class="profile-header">
            <div class="profile-avatar">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="profile-info">
                <h2>${user.fullName}</h2>
                <p>${user.email}</p>
            </div>
            <div class="profile-actions">
                <button id="edit-profile-btn" class="btn btn-primary">
                    <i class="fas fa-edit"></i> Edit Profile
                </button>
                <form action="${pageContext.request.contextPath}/auth/logout" method="post" class="logout-form">
                    <button id="logout-btn" type="submit" class="btn btn-danger">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </button>
                </form>
            </div>
        </div>

        <div class="profile-stats">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-code"></i>
                </div>
                <div class="stat-content">
                    <h3>Problems Solved</h3>
                    <p>${user.solvedProblemsCount}</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-fire"></i>
                </div>
                <div class="stat-content">
                    <h3>Current Streak</h3>
                    <p>${user.currentStreak} days</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-trophy"></i>
                </div>
                <div class="stat-content">
                    <h3>Best Streak</h3>
                    <p>${user.bestStreak} days</p>
                </div>
            </div>
        </div>


        <div class="activity-section">
            <h3>Activity Overview</h3>
            <div class="activity-grid" id="activity-grid" data-activity="${user.activity}">

            </div>


            <div class="activity-legend">
                <span>Less</span>
                <div class="legend-squares">
                    <div class="activity-square level-0"></div>
                    <div class="activity-square level-1"></div>
                    <div class="activity-square level-2"></div>
                    <div class="activity-square level-3"></div>
                    <div class="activity-square level-4"></div>
                </div>
                <span>More</span>
            </div>
        </div>

        <%--        <div class="activity-section">--%>
        <%--            <h3>Activity Overview</h3>--%>
        <%--            <div class="activity-grid" id="activity-grid">--%>
        <%--                <!-- Static activity grid will be generated by JavaScript -->--%>
        <%--            </div>--%>
        <%--            <div class="activity-legend">--%>
        <%--                <span>Less</span>--%>
        <%--                <div class="legend-squares">--%>
        <%--                    <div class="activity-square level-0"></div>--%>
        <%--                    <div class="activity-square level-1"></div>--%>
        <%--                    <div class="activity-square level-2"></div>--%>
        <%--                    <div class="activity-square level-3"></div>--%>
        <%--                    <div class="activity-square level-4"></div>--%>
        <%--                </div>--%>
        <%--                <span>More</span>--%>
        <%--            </div>--%>
        <%--        </div>--%>
    </main>

    <div class="modal" id="edit-profile-modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Profile</h3>
                <button class="close-btn">&times;</button>
            </div>
            <div class="modal-body">
                <form action="${pageContext.request.contextPath}/profile/edit" method="post">
                    <div class="form-group">
                        <label for="edit-username">Full name</label>
                        <input type="text" id="edit-username" value="${user.fullName}" required>
                    </div>
                    <div class="form-group">
                        <label for="edit-email">Email</label>
                        <input type="email" id="edit-email" value="${user.email}">
                    </div>
                    <div class="form-group">
                        <label for="edit-website">Password</label>
                        <input type="password" id="edit-website" value="${user.password}"
                               placeholder="* * * * * *">
                    </div>
                    <div class="form-actions">
                        <button type="button" class="btn btn-outline" id="cancel-edit-btn">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="assets/js/theme.js"></script>
<script src="assets/js/profile.js"></script>

</body>
</html>
