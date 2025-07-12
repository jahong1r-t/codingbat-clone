package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.payload.TestResultDTO;
import uz.codingbat.codingbatclone.payload.TestSummaryDTO;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

public class ProblemService {
    private final CompileService compileService = new CompileService();
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    @SneakyThrows
    public void run(HttpServletRequest req, HttpServletResponse resp) {
        String code = req.getParameter("code");
        String id = req.getParameter("id");

        TestSummaryDTO results = compileService.summarizeTestResults(compileService.compile(code, id), code);
        req.getSession().setAttribute("results", results);

        if (isSessionValid(req)) {
            try (EntityManager entityManager = jpaConnection.entityManager()) {
                entityManager.persist(results);
            }

            req.getRequestDispatcher("results.jsp").forward(req, resp);
            resp.sendRedirect("/problem?id=" + id + "&run=" + true);
            return;
        }

        System.err.println(results.getCode() + "\n" + results.getPassed() + "\n" + results.getFailed() + "\n" + results.getError());
        for (TestResultDTO detail : results.getDetails()) {
            System.err.println(detail);
        }

        resp.sendRedirect("/problem?id=" + id + "&run=" + true);
    }
}
