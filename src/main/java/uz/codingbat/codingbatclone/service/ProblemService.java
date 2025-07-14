package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.TestCase;
import uz.codingbat.codingbatclone.entity.UserActivity;
import uz.codingbat.codingbatclone.entity.enums.SolveStatus;
import uz.codingbat.codingbatclone.payload.CacheDTO;
import uz.codingbat.codingbatclone.payload.resp.ProblemRespDTO;
import uz.codingbat.codingbatclone.payload.TestCaseDTO;
import uz.codingbat.codingbatclone.payload.TestSummaryDTO;

import java.io.IOException;
import java.util.*;

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
                entityManager.getTransaction().begin();
                entityManager.find(UserActivity.class, req.getSession().getAttribute("user_id"));


                entityManager.getTransaction().commit();
            }
            resp.sendRedirect("/problem?id=" + id + "&run=" + true);
            return;
        }

        Map<String, CacheDTO> cache = (Map<String, CacheDTO>)
                req.getSession().getAttribute("cache");

        CacheDTO build = CacheDTO.builder()
                .code(code)
                .status(results.getError() == 0 && results.getFailed() == 0 ? SolveStatus.SOLVED : SolveStatus.OPENED)
                .build();

        cache.put(id, build);

        req.getSession().setAttribute("cache", cache);

        resp.sendRedirect("/problem?id=" + id + "&run=" + true);
    }

    public void addProblem(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    }

    public void getProblem(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (EntityManager entityManager = jpaConnection.entityManager()) {
            Problem problem = entityManager
                    .createQuery("SELECT p FROM Problem p WHERE p.id = :id", Problem.class)
                    .setParameter("id", UUID.fromString(req.getParameter("id")))
                    .getSingleResult();

            List<TestCase> resultList = entityManager.createQuery("SELECT t from TestCase t where t.problem.id = :id", TestCase.class)
                    .setParameter("id", UUID.fromString(req.getParameter("id")))
                    .getResultList();

            List<TestCaseDTO> list = resultList.stream().map(t -> TestCaseDTO.builder()
                    .input(t.getInput())
                    .output(t.getOutput())
                    .hidden(t.getIsHidden())
                    .build()).toList();


            ProblemRespDTO build = ProblemRespDTO.builder()
                    .id(problem.getId())
                    .title(problem.getTitle())
                    .description(problem.getDescription())
                    .difficulty(problem.getDifficulty())
                    .codeTemplate(problem.getCodeTemplate())
                    .testCases(list)
                    .build();

            req.setAttribute("problem", build);

            Map<String, CacheDTO> cache = (Map<String, CacheDTO>) req.getSession().getAttribute("cache");

            if (cache == null) {
                cache = new HashMap<>();
                CacheDTO cacheDTO = CacheDTO.builder()
                        .status(SolveStatus.OPENED)
                        .build();
                cache.put(problem.getId().toString(), cacheDTO);
                req.getSession().setAttribute("cache", cache);
            }

            req.setAttribute("f_code", req.getSession().getAttribute("f_code"));
            req.getRequestDispatcher("problem.jsp").forward(req, resp);

            req.getSession().removeAttribute("f_code");
        }

    }
}
