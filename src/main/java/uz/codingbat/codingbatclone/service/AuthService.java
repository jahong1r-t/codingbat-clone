package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.User;
import uz.codingbat.codingbatclone.entity.enums.Role;

import java.io.IOException;

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

        EntityManager entityManager = jdbc.entityManager();
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

        req.getSession().setAttribute("user_id", user.getId());
        req.getSession().setAttribute("role", user.getRole());
        req.getSession().setAttribute("is_authenticated", true);
        entityManager.close();

        resp.sendRedirect("/");
    }

    @SneakyThrows
    public void signUp(HttpServletRequest req, HttpServletResponse resp) {
        String fullName = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (isValidEmail(email) || isValidPassword(password) || !isValidFullName(fullName)) {
            req.setAttribute("error", "Please provide a valid email, password (at least 6 characters), and full name.");
            try {
                req.getRequestDispatcher("auth.jsp").forward(req, resp);
            } catch (ServletException e) {
                throw new RuntimeException(e);
            } catch (IOException e) {
                System.err.println(e.getMessage());
            }
            return;
        }

        EntityManager entityManager = jdbc.entityManager();

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
        entityManager.getTransaction().commit();
        entityManager.close();

        req.getSession().setAttribute("user_id", user.getId());
        req.getSession().setAttribute("role", user.getRole());
        req.getSession().setAttribute("is_authenticated", true);

        resp.sendRedirect("/");

    }

    @SneakyThrows
    public void logOut(HttpServletRequest req, HttpServletResponse resp) {
        req.getSession().invalidate();
        resp.sendRedirect("/");
    }

    public synchronized static AuthService getInstance() {
        if (instance == null) {
            instance = new AuthService();
        }
        return instance;
    }
}
