package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.TestCase;
import uz.codingbat.codingbatclone.payload.ProblemDTO;
import uz.codingbat.codingbatclone.payload.StatsDTO;
import uz.codingbat.codingbatclone.payload.TestCaseDTO;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

public class AdminService {
    private final JpaConnection jdbc = JpaConnection.getInstance();

    @SneakyThrows
    public void admin(HttpServletRequest req, HttpServletResponse resp) {
        try (EntityManager entityManager = jdbc.entityManager()) {

            long totalProblems = entityManager
                    .createQuery("SELECT COUNT(p) FROM Problem p", Long.class)
                    .getSingleResult();

            long totalUsers = entityManager
                    .createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'USER'", Long.class)
                    .getSingleResult();

            Problem lastProblem = entityManager.createQuery(
                            "SELECT p FROM Problem p ORDER BY p.createdAt DESC", Problem.class)
                    .setMaxResults(1)
                    .getSingleResult();

            List<Problem> mostSolvedList = entityManager.createQuery("""
                            SELECT s.problem
                            FROM Solution s
                            WHERE s.passed = true
                            GROUP BY s.problem
                            ORDER BY COUNT(s.id) DESC
                            """, Problem.class)
                    .setMaxResults(1)
                    .getResultList();


            Problem mostSolvedProblem = mostSolvedList.isEmpty() ? null : mostSolvedList.get(0);


            int page = Math.max(0, parseIntOrDefault(req.getParameter("page"), 1) - 1);
            int size = Math.max(1, parseIntOrDefault(req.getParameter("size"), 16));

            List<Problem> problems = entityManager.createQuery(
                            "SELECT p FROM Problem p", Problem.class)
                    .setFirstResult(page * size)
                    .setMaxResults(size)
                    .getResultList();

            List<UUID> problemIds = problems.stream()
                    .map(Problem::getId)
                    .toList();


            List<TestCase> testCases = entityManager.createQuery("""
                            SELECT t FROM TestCase t
                            WHERE t.problem.id IN :ids
                            """, TestCase.class)
                    .setParameter("ids", problemIds)
                    .getResultList() ;

            Map<UUID, List<TestCase>> testCaseMap = testCases.stream()
                    .collect(Collectors.groupingBy(tc -> tc.getProblem().getId()));


            List<ProblemDTO> problemDTOs = problems.stream()
                    .map(p -> {
                        List<TestCaseDTO> tcList = testCaseMap.getOrDefault(p.getId(), List.of()).stream()
                                .map(tc -> TestCaseDTO.builder()
                                        .input(tc.getInput())
                                        .output(tc.getOutput())
                                        .hidden(false)
                                        .build())
                                .toList();

                        return ProblemDTO.builder()
                                .id(p.getId())
                                .title(p.getTitle())
                                .difficulty(p.getDifficulty())
                                .description(p.getDescription())
                                .codeTemplate(p.getCodeTemplate())
                                .testCases(tcList)
                                .build();
                    })
                    .toList();



            int totalPages = (int) Math.ceil((double) totalProblems / size);
            int currentPage = page + 1;
            int next = Math.min(currentPage + 1, totalPages);
            int previous = Math.max(currentPage - 1, 1);

            StatsDTO stats = StatsDTO.builder()
                    .totalProblems(totalProblems)
                    .totalUsers(totalUsers)
                    .latestProblem(lastProblem != null ? lastProblem.getTitle() : "N/A")
                    .mostSolved(mostSolvedProblem != null ? mostSolvedProblem.getTitle() : "N/A")
                    .build();

            req.setAttribute("stats", stats);
            req.setAttribute("problems", problemDTOs);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("next", next);
            req.setAttribute("previous", previous);
            req.setAttribute("size", size);
        }

        req.getRequestDispatcher("admin.jsp").forward(req, resp);
    }

    private int parseIntOrDefault(String val, int defaultVal) {
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

}
