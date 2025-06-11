package uz.codingbat.codingbatclone.controller;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/problem")
public class ProblemController extends HttpServlet {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (EntityManager entityManager = jpaConnection.entityManager()) {
            Problem problem = entityManager
                    .createQuery("SELECT p FROM Problem p LEFT JOIN FETCH p.testCases WHERE p.id = :id", Problem.class)
                    .setParameter("id", UUID.fromString(req.getParameter("id")))
                    .getSingleResult();

            req.setAttribute("problem", problem);

            req.setAttribute("f_code", req.getSession().getAttribute("f_code"));
            req.getRequestDispatcher("problem.jsp").forward(req, resp);

            req.getSession().removeAttribute("f_code");
        }
    }
}
