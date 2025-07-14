package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.enums.Difficulty;
import uz.codingbat.codingbatclone.payload.resp.PageRespDTO;

import java.io.IOException;
import java.util.List;

public class MainService {
    private static MainService instance;
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (EntityManager entityManager = jpaConnection.entityManager()) {
            String pageParam = req.getParameter("page");
            String filter = req.getParameter("filter");
            String sizeParam = req.getParameter("size");

            int page = 0;
            if (pageParam != null) {
                page = Integer.parseInt(pageParam) - 1;
                if (page < 0) page = 0;
            }

            int size = 16;
            if (sizeParam != null) {
                size = Integer.parseInt(sizeParam);
                if (size <= 0) size = 16;
            }


            if (filter == null || filter.isEmpty()) {
                List<Problem> problems = entityManager
                        .createQuery("select p from Problem p", Problem.class)
                        .setFirstResult(page * size)
                        .setMaxResults(size)
                        .getResultList();

                Long totalProblems = entityManager
                        .createQuery("select count(p.id) from Problem p", Long.class)
                        .getSingleResult();

                PageRespDTO<?> pageRespDTO = setPagination(totalProblems, size, page, problems, null);

                req.setAttribute("page", pageRespDTO);

            } else {
                List<Problem> problems = entityManager
                        .createQuery("select p from Problem p where difficulty = :d", Problem.class)
                        .setFirstResult(page * size)
                        .setParameter("d", parseDifficulty(filter))
                        .setMaxResults(size)
                        .getResultList();

                Long totalProblems = entityManager.createQuery("select count(p.id) from Problem p where difficulty = :d", Long.class)
                        .setParameter("d", parseDifficulty(filter))
                        .getSingleResult();

                PageRespDTO<?> pageRespDTO = setPagination(totalProblems, size, page, problems, filter);

                req.setAttribute("page", pageRespDTO);
            }

        }

        req.getRequestDispatcher("index.jsp").forward(req, resp);
    }

    protected PageRespDTO<?> setPagination(Long totalProblems, int size, int page, List<?> problems, String filter) {
        int totalPages = (int) Math.ceil((double) totalProblems / size);

        int currentPage = page + 1;
        int next = (currentPage + 1 <= totalPages) ? currentPage + 1 : currentPage;
        int previous = (currentPage > 1) ? currentPage - 1 : 1;

        return PageRespDTO.<Problem>builder()
                .content(problems)
                .currentPage(currentPage)
                .totalPages(totalPages)
                .nextPage(next)
                .previousPage(previous)
                .size(size)
                .filter(filter)
                .build();
    }

    private

    private Difficulty parseDifficulty(String filter) {
        try {
            return Difficulty.valueOf(filter.toUpperCase());
        } catch (IllegalArgumentException | NullPointerException e) {
            return null;
        }
    }

    public static MainService getInstance() {
        if (instance == null) {
            instance = new MainService();
        }
        return instance;
    }
}
