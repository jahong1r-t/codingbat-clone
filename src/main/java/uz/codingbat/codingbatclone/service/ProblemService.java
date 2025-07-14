package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.*;
import uz.codingbat.codingbatclone.entity.enums.SolveStatus;
import uz.codingbat.codingbatclone.payload.CacheDTO;
import uz.codingbat.codingbatclone.payload.resp.ProblemRespDTO;
import uz.codingbat.codingbatclone.payload.TestCaseDTO;
import uz.codingbat.codingbatclone.payload.TestSummaryDTO;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
                User user = entityManager.find(User.class, req.getSession().getAttribute("user_id"));
                if (results.getError() == 0 && results.getFailed() == 0) {
                    UserActivity date = entityManager.createQuery("select a from UserActivity a where a.date = :date", UserActivity.class)
                            .setParameter("date", LocalDate.now())
                            .getSingleResultOrNull();

                    UserStats stats = entityManager.createQuery("SELECT s from UserStats s where s.user.id = :user_id", UserStats.class)
                            .setParameter("user_id", user.getId())
                            .getSingleResultOrNull();

                    LocalDate today = LocalDate.now();
                    LocalDate yesterday = today.minusDays(1);

                    if (date == null) {
                        UserActivity build = UserActivity.builder()
                                .date(today)
                                .problemsSolved(1)
                                .user(user)
                                .build();

                        entityManager.persist(build);
                    } else {
                        date.setProblemsSolved(date.getProblemsSolved() + 1);
                        entityManager.merge(date);
                    }

                    if (stats.getLastSolvedDate() == null || stats.getLastSolvedDate().isBefore(yesterday)) {
                        stats.setCurrentStreak(1);
                    } else if (stats.getLastSolvedDate().isEqual(yesterday)) {
                        stats.setCurrentStreak(stats.getCurrentStreak() + 1);
                    }

                    if (stats.getCurrentStreak() > stats.getBestStreak()) {
                        stats.setBestStreak(stats.getCurrentStreak());
                    }


                    stats.setSolvedProblemsCount(stats.getSolvedProblemsCount() + 1);
                    stats.setLastSolvedDate(today);

                    manageSolution(req, entityManager, entityManager.find(Problem.class, UUID.fromString(id)), true, code);

                    entityManager.merge(stats);
                }

                entityManager.getTransaction().commit();
            }

        }

        CacheDTO build = CacheDTO.builder()
                .code(code)
                .status(results.getError() == 0 && results.getFailed() == 0 ? SolveStatus.SOLVED : SolveStatus.OPENED)
                .build();

        Map<String, CacheDTO> cache = (Map<String, CacheDTO>)
                req.getSession().getAttribute("cache");

        cache.put(id, build);

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

            if (isSessionValid(req)) {
                entityManager.getTransaction().begin();
                UUID userId = (UUID) req.getSession().getAttribute("user_id");
                User user = entityManager.find(User.class, userId);

                List<Solution> existingSolutions = entityManager.createQuery(" SELECT s FROM Solution s WHERE s.user = :user AND s.problem = :problem ", Solution.class)
                        .setParameter("user", user)
                        .setParameter("problem", problem)
                        .getResultList();


                System.err.println(existingSolutions.isEmpty());

                if (existingSolutions.isEmpty()) {

                    Solution solution = Solution.builder()
                            .user(user)
                            .problem(problem)
                            .code(problem.getCodeTemplate())
                            .solveStatus(SolveStatus.OPENED)
                            .build();

                    entityManager.persist(solution);
                    entityManager.getTransaction().commit();
                }
            }

            req.setAttribute("problem", build);

            Map<String, CacheDTO> cache = (Map<String, CacheDTO>) req.getSession().getAttribute("cache");

            if (cache == null) {
                cache = new HashMap<>();
                CacheDTO cacheDTO = CacheDTO.builder()
                        .status(SolveStatus.OPENED)
                        .build();
                cache.putIfAbsent(problem.getId().toString(), cacheDTO);
            } else {
                CacheDTO cacheDTO = CacheDTO.builder()
                        .status(SolveStatus.OPENED)
                        .build();
                cache.putIfAbsent(problem.getId().toString(), cacheDTO);
            }

            req.getSession().setAttribute("cache", cache);
            req.getRequestDispatcher("problem.jsp").forward(req, resp);
        }

    }

    private void manageSolution(HttpServletRequest req, EntityManager entityManager, Problem problem, Boolean isSolved, String code) throws IOException {
        UUID userId = (UUID) req.getSession().getAttribute("user_id");
        User user = entityManager.find(User.class, userId);

        List<Solution> existingSolutions = entityManager.createQuery(" SELECT s FROM Solution s WHERE s.user = :user AND s.problem = :problem ", Solution.class)
                .setParameter("user", user)
                .setParameter("problem", problem)
                .getResultList();

        if (existingSolutions.isEmpty()) {
            Solution solution = Solution.builder()
                    .user(user)
                    .problem(problem)
                    .code(problem.getCodeTemplate())
                    .solveStatus(isSolved ? SolveStatus.SOLVED : SolveStatus.OPENED)
                    .build();

            entityManager.persist(solution);
            return;
        }

        Solution solution = existingSolutions.get(0);
        solution.setSolveStatus(isSolved ? SolveStatus.SOLVED : SolveStatus.OPENED);
        solution.setCode(code);

        entityManager.merge(solution);
    }
}
