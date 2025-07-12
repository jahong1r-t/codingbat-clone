package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.enums.SolveStatus;
import uz.codingbat.codingbatclone.payload.CacheDTO;
import uz.codingbat.codingbatclone.payload.TestSummaryDTO;

import java.io.IOException;
import java.util.Map;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

public class ProblemService {
    private final CompileService compileService = new CompileService();
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public void run(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String code = req.getParameter("code");
        String id = req.getParameter("id");

        TestSummaryDTO results = compileService.summarizeTestResults(compileService.compile(code, id), code);
        req.getSession().setAttribute("results", results);

        if (isSessionValid(req)) {
            try (EntityManager entityManager = jpaConnection.entityManager()) {

            }
            resp.sendRedirect("/problem?id=" + id + "&run=" + true);
            return;
        }

        Map<String, CacheDTO> cache = (Map<String, CacheDTO>)
                req.getSession().getAttribute("cache");

        cache.forEach((k, v) -> System.out.println("Problem: "+k + ": " + v));


        CacheDTO build = CacheDTO.builder()
                .code(code)
                .status(results.getPassed() == 4 ? SolveStatus.SOLVED : SolveStatus.OPENED)
                .build();

        cache.put(id, build);

        req.getSession().setAttribute("cache", cache);


        cache.forEach((k, v) -> System.out.println("After: "+k + ": " + v));


        resp.sendRedirect("/problem?id=" + id + "&run=" + true);
    }
}
