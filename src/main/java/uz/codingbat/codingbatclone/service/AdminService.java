package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.enums.Role;
import uz.codingbat.codingbatclone.payload.StatsDTO;
import uz.codingbat.codingbatclone.payload.resp.PageRespDTO;
import uz.codingbat.codingbatclone.payload.resp.ProblemRespDTO;

import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

public class AdminService {
    private static AdminService instance;
    private final JpaConnection jdbc = JpaConnection.getInstance();
    private final MainService mainService = MainService.getInstance();

    @SneakyThrows
    public void admin(HttpServletRequest req, HttpServletResponse resp) {
        try (EntityManager entityManager = jdbc.entityManager()) {

            int page = Math.max(0, parseIntOrDefault(req.getParameter("page"), 1) - 1);
            int size = Math.max(1, parseIntOrDefault(req.getParameter("size"), 16));

            Long totalProblems = entityManager
                    .createQuery("SELECT COUNT(p) FROM Problem p", Long.class)
                    .getSingleResult();
//
//            Long totalUsers = entityManager
//                    .createQuery("SELECT COUNT(u) FROM User u WHERE u.role = 'USER'", Long.class)
//                    .getSingleResult();
//
//            Problem lastProblem = entityManager.createQuery(
//                            "SELECT p FROM Problem p ORDER BY p.createdAt DESC", Problem.class)
//                    .setMaxResults(1)
//                    .getSingleResult();
//
//            List<Problem> mostSolvedList = entityManager.createQuery("""
//                            SELECT s.problem
//                            FROM Solution s
//                            WHERE s.passed = true
//                            GROUP BY s.problem
//                            ORDER BY COUNT(s.id) DESC
//                            """, Problem.class)
//                    .setMaxResults(1)
//                    .getResultList();


//            Problem mostSolvedProblem = mostSolvedList.isEmpty() ? null : mostSolvedList.get(0);


            List<Problem> problems = entityManager.createQuery(
                            "SELECT p FROM Problem p", Problem.class)
                    .setFirstResult(page * size)
                    .setMaxResults(size)
                    .getResultList();

            List<UUID> problemIds = problems.stream()
                    .map(Problem::getId)
                    .toList();


            List<Object[]> rows = entityManager.createQuery("""
                                SELECT t.problem.id, COUNT(t)
                                FROM TestCase t
                                WHERE t.problem.id IN :ids
                                GROUP BY t.problem.id
                            """, Object[].class)
                    .setParameter("ids", problemIds)
                    .getResultList();

            Map<UUID, Long> testCaseCountMap = rows.stream()
                    .collect(Collectors.toMap(
                            row -> (UUID) row[0],
                            row -> (Long) row[1]
                    ));

            List<ProblemRespDTO> problemRespDTO = problems.stream()
                    .map(p -> {
                        return ProblemRespDTO.builder()
                                .id(p.getId())
                                .title(p.getTitle())
                                .difficulty(p.getDifficulty())
                                .description(p.getDescription())
                                .codeTemplate(p.getCodeTemplate())
                                .testCaseCount(testCaseCountMap.getOrDefault(p.getId(), 0L))
                                .build();
                    })
                    .toList();


//            List<TestCase> testCases = entityManager.createQuery("""
//                            SELECT t FROM TestCase t
//                            WHERE t.problem.id IN :ids
//                            """, TestCase.class)
//                    .setParameter("ids", problemIds)
//                    .getResultList();
//
//            Map<UUID, List<Integer>> testCaseMap = ids.stream()
//                    .collect(Collectors.groupingBy(tc -> tc.getId()));
//
//
//            List<ProblemRespDTO> problemDTOs = problems.stream()
//                    .map(p -> {
//                        List<TestCaseDTO> tcList = testCaseMap.getOrDefault(p.getId(), List.of()).stream()
//                                .map(tc -> TestCaseDTO.builder()
//                                        .input(tc.getInput())
//                                        .output(tc.getOutput())
//                                        .hidden(false)
//                                        .build())
//                                .toList();
//
//                        return ProblemRespDTO.builder()
//                                .id(p.getId())
//                                .title(p.getTitle())
//                                .difficulty(p.getDifficulty())
//                                .description(p.getDescription())
//                                .codeTemplate(p.getCodeTemplate())
//                                .testCases(tcList)
//                                .build();
//                    })
//                    .toList();


//            int totalPages = (int) Math.ceil((double) totalProblems / size);
//            int currentPage = page + 1;


//            int next = Math.min(currentPage + 1, totalPages);
//            int previous = Math.max(currentPage - 1, 1);

            PageRespDTO<?> pageRespDTO = mainService.setPagination(totalProblems, size, page, problemRespDTO, null);

            req.setAttribute("stats", getStats(entityManager, totalProblems));
            req.setAttribute("page", pageRespDTO);

//            req.setAttribute("problems", problemDTOs);
//            req.setAttribute("totalPages", totalPages);
//            req.setAttribute("currentPage", currentPage);
//            req.setAttribute("next", next);
//            req.setAttribute("previous", previous);
//            req.setAttribute("size", size);
        }

        req.getRequestDispatcher("admin.jsp").forward(req, resp);
    }

    private StatsDTO getStats(EntityManager em, Long totalProblems) {

        long totalUsers = em.createQuery("SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class)
                .setParameter("role", Role.USER)
                .getSingleResult();

        Problem lastProblem = em.createQuery("SELECT p FROM Problem p ORDER BY p.createdAt DESC", Problem.class)
                .setMaxResults(1)
                .getResultStream().findFirst().orElse(null);

        Problem mostSolved = em.createQuery("""
                        SELECT s.problem FROM Solution s WHERE s.passed = true
                        GROUP BY s.problem ORDER BY COUNT(s.id) DESC
                        """, Problem.class)
                .setMaxResults(1)
                .getResultStream().findFirst().orElse(null);

        return StatsDTO.builder()
                .totalProblems(totalProblems)
                .totalUsers(totalUsers)
                .latestProblem(lastProblem != null ? lastProblem.getTitle() : "N/A")
                .mostSolved(mostSolved != null ? mostSolved.getTitle() : "N/A")
                .build();
    }


    private int parseIntOrDefault(String val, int defaultVal) {
        try {
            return Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    public static AdminService getInstance() {
        if (instance == null) {
            instance = new AdminService();
        }

        return instance;
    }

}
