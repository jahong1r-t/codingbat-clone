package uz.codingbat.codingbatclone.controller;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.service.CompileService;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/problem/*")
public class ProblemController extends HttpServlet {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();
    private final CompileService compileService = new CompileService();

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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("/run".equals(req.getPathInfo())) {
            String code = req.getParameter("code");
            String id = req.getParameter("id");
            System.err.println(code + " " + id);

            compileService.compile(code, id).forEach((k, v) -> {
                System.out.println("Compiling " + k + " with " + v);
            });

            resp.sendRedirect("/problem?id=" + id + "&result=" + true);
        }
    }
}
