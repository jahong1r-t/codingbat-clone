package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.User;
import uz.codingbat.codingbatclone.entity.UserActivity;
import uz.codingbat.codingbatclone.entity.UserStats;
import uz.codingbat.codingbatclone.payload.ProfileDTO;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ProfileService {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();
    private static ProfileService instance;

    public void getProfile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (EntityManager entityManager = jpaConnection.entityManager()) {
            UUID userId = (UUID) req.getSession().getAttribute("user_id");
            User user = entityManager.find(User.class, userId);

            UserStats stats = entityManager.createQuery("select s from UserStats s where s.user.id = :id", UserStats.class)
                    .setParameter("id", userId)
                    .getSingleResultOrNull();

            List<UserActivity> activities = entityManager.createQuery(
                            "select u from UserActivity u where u.user.id = :id", UserActivity.class)
                    .setParameter("id", userId)
                    .getResultList();

            Map<LocalDate, Integer> activityMap = new HashMap<>();
            for (UserActivity activity : activities) {
                activityMap.put(activity.getDate(), activity.getProblemsSolved());
            }

            ProfileDTO dto = ProfileDTO.builder()
                    .id(user.getId())
                    .fullName(user.getFullName())
                    .email(user.getEmail())
                    .password(user.getPassword())
                    .role(user.getRole())
                    .solvedProblemsCount(stats != null ? stats.getSolvedProblemsCount() : 0)
                    .currentStreak(stats != null ? stats.getCurrentStreak() : 0)
                    .bestStreak(stats != null ? stats.getBestStreak() : 0)
                    .activity(activityMap)
                    .build();

            req.setAttribute("user", dto);
        }

        req.getRequestDispatcher("profile.jsp").forward(req, resp);
    }

    public static ProfileService getInstance() {
        if (instance == null) {
            instance = new ProfileService();
        }
        return instance;
    }

    public void updateProfile(HttpServletRequest req, HttpServletResponse resp) {
    }
}
