package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;

import java.io.IOException;
import java.util.List;

public class MainService {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user_id") != null
                && req.getSession().getAttribute("role") == "USER"
                && req.getSession().getAttribute("is_authenticated").equals("true")) {

        } else {
            EntityManager entityManager = jpaConnection.entityManager();
            List<Problem> problems = entityManager.createQuery("select p from Problem p", Problem.class).getResultList();
            req.setAttribute("problems", problems);
            entityManager.close();

            problems.forEach(System.out::println);

            req.getRequestDispatcher("index.jsp").forward(req, resp);
        }
    }

    private void handleUserService(HttpServletRequest req, HttpServletResponse resp) {

    }

    private void handleGuestService(HttpServletRequest req, HttpServletResponse resp) {

    }
}
