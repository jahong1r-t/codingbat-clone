package uz.codingbat.codingbatclone.service;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.enums.Difficulty;

import java.io.IOException;
import java.util.List;

public class MainService {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public void service(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user_id") != null
                && req.getSession().getAttribute("is_authenticated").equals("true")) {
            System.err.println("Hello world!");
        } else {
            EntityManager entityManager = jpaConnection.entityManager();
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


            List<Problem> problems = entityManager
                    .createQuery("select p from Problem p ", Problem.class)
                    .setFirstResult(page * size)
                    .setMaxResults(size)
                    .getResultList();

            Long totalProblems = entityManager.createQuery("select count(p.id) from Problem p", Long.class).getSingleResult();


            int totalPages = (int) Math.ceil((double) totalProblems / size);

            int currentPage = page + 1;
            int next = (currentPage + 1 <= totalPages) ? currentPage + 1 : currentPage;
            int previous = (currentPage > 1) ? currentPage - 1 : 1;

            req.setAttribute("next", next);
            req.setAttribute("previous", previous);
            req.setAttribute("size", size);
            req.setAttribute("problems", problems);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("filter", filter);


            req.getRequestDispatcher("index.jsp").forward(req, resp);
            entityManager.close();
        }
    }

    private void handleUserService(HttpServletRequest req, HttpServletResponse resp) {

    }

    private void handleGuestService(HttpServletRequest req, HttpServletResponse resp) {

    }
}
