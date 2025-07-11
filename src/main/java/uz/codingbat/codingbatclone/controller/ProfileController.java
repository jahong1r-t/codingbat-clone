package uz.codingbat.codingbatclone.controller;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.User;
import uz.codingbat.codingbatclone.entity.UserActivity;
import uz.codingbat.codingbatclone.entity.UserStats;
import uz.codingbat.codingbatclone.payload.ProfileDTO;
import uz.codingbat.codingbatclone.payload.UserDTO;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isSessionValid(req)) {
            try (EntityManager entityManager = jpaConnection.entityManager()) {
                UUID userId = (UUID) req.getSession().getAttribute("user_id");
                User user = entityManager.find(User.class, userId);

                UserStats stats = entityManager.createQuery("select s from UserStats s where s.user.id= :id", UserStats.class)
                        .setParameter("id", userId)
                        .getSingleResultOrNull();

                List<UserActivity> resultList = entityManager.createQuery(
                                "select u from UserActivity u where u.user.id = :id", UserActivity.class)
                        .setParameter("id", userId)
                        .getResultList();

                Map<String, Integer> activityMap = resultList.stream()
                        .collect(Collectors.toMap(
                                activity -> activity.getDate().toString(),
                                UserActivity::getProblemsSolved
                        ));

                ProfileDTO dto = ProfileDTO.builder()
                        .fullName(user.getFullName())
                        .email(user.getEmail())
                        .password(user.getPassword())
                        .role(user.getRole())
                        .solvedProblemsCount(stats.getSolvedProblemsCount())
                        .currentStreak(stats.getCurrentStreak())
                        .bestStreak(stats.getBestStreak())
                        .activity(activityMap)
                        .build();

                req.setAttribute("user", dto);
            }

            req.getRequestDispatcher("profile.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }
}
