package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Solution;
import uz.codingbat.codingbatclone.entity.User;
import uz.codingbat.codingbatclone.entity.UserStats;
import uz.codingbat.codingbatclone.entity.enums.Role;
import uz.codingbat.codingbatclone.payload.CacheDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static uz.codingbat.codingbatclone.utils.Util.*;

public class AuthService {
    private static AuthService instance;
    private final JpaConnection jdbc = JpaConnection.getInstance();

    @SneakyThrows
    public void signIn(HttpServletRequest req, HttpServletResponse resp) {
        String password = req.getParameter("password");
        String email = req.getParameter("email");

        if (isValidEmail(email) || isValidPassword(password)) {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/auth.jsp").forward(req, resp);

            return;
        }

        try (EntityManager entityManager = jdbc.entityManager()) {
            User user = entityManager
                    .createQuery("SELECT u FROM User u WHERE u.email = :email and u.password = :password", User.class)
                    .setParameter("email", email)
                    .setParameter("password", password)
                    .getSingleResultOrNull();

            if (user == null) {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("auth.jsp").forward(req, resp);

                return;
            }
            req.getSession().removeAttribute("cache");

            req.getSession().setAttribute("user_id", user.getId());
            req.getSession().setAttribute("role", user.getRole());
            req.getSession().setAttribute("is_authenticated", true);
            req.getSession().setAttribute("cache", initUserData(entityManager, user.getId()));

            if (user.getRole() == Role.ADMIN) {
                resp.sendRedirect("/admin");
                return;
            }
        }

        resp.sendRedirect("/");
    }

    @SneakyThrows
    public void signUp(HttpServletRequest req, HttpServletResponse resp) {
        String fullName = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (isValidEmail(email) || isValidPassword(password) || !isValidFullName(fullName)) {
            req.setAttribute("error", "Please provide a valid email, password (at least 6 characters), and full name.");
            req.getRequestDispatcher("/auth.jsp").forward(req, resp);
            return;
        }

        try (EntityManager entityManager = jdbc.entityManager()) {
            if (entityManager.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                    .setParameter("email", email)
                    .getSingleResultOrNull() != null
            ) {
                req.setAttribute("error", "Email already in use");
                req.getRequestDispatcher("auth.jsp").forward(req, resp);
                return;
            }

            entityManager.getTransaction().begin();

            User user = User.builder()
                    .fullName(fullName)
                    .email(email)
                    .password(password)
                    .role(Role.USER)
                    .build();

            entityManager.persist(user);

            UserStats build = UserStats.builder()
                    .currentStreak(0)
                    .bestStreak(0)
                    .solvedProblemsCount(0)
                    .user(user)
                    .build();

            entityManager.persist(build);
            entityManager.getTransaction().commit();

            req.getSession().removeAttribute("cache");
            req.getSession().setAttribute("user_id", user.getId());
            req.getSession().setAttribute("role", user.getRole());
            req.getSession().setAttribute("is_authenticated", true);
        }

        resp.sendRedirect("/");

    }

    @SneakyThrows
    public void logOut(HttpServletRequest req, HttpServletResponse resp) {
        req.getSession().invalidate();
        resp.sendRedirect("/");
    }

    public Map<String, CacheDTO> initUserData(EntityManager entityManager, UUID id) {
        List<Solution> solutions = entityManager.createQuery("select s from Solution s where s.user.id = :id", Solution.class)
                .setParameter("id", id)
                .getResultList();

        Map<String, CacheDTO> solutionMap = new HashMap<>();

        for (Solution solution : solutions) {
            CacheDTO build = CacheDTO.builder()
                    .code(solution.getCode())
                    .status(solution.getSolveStatus())
                    .build();
            solutionMap.put(solution.getProblem().getId().toString(), build);
        }

        return solutionMap;
    }

    public static AuthService getInstance() {
        if (instance == null) {
            instance = new AuthService();
        }
        return instance;
    }
}
