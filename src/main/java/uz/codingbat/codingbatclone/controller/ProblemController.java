package uz.codingbat.codingbatclone.controller;

import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.Problem;
import uz.codingbat.codingbatclone.entity.TestCase;
import uz.codingbat.codingbatclone.payload.ProblemDTO;
import uz.codingbat.codingbatclone.payload.TestCaseDTO;
import uz.codingbat.codingbatclone.service.CompileService;
import uz.codingbat.codingbatclone.service.ProblemService;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/problem/*")
public class ProblemController extends HttpServlet {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();
    private final ProblemService problemService=new ProblemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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


            ProblemDTO build = ProblemDTO.builder()
                    .id(problem.getId())
                    .title(problem.getTitle())
                    .description(problem.getDescription())
                    .difficulty(problem.getDifficulty())
                    .codeTemplate(problem.getCodeTemplate())
                    .testCases(list)
                    .build();

            req.setAttribute("problem", build);

            req.setAttribute("f_code", req.getSession().getAttribute("f_code"));
            req.getRequestDispatcher("problem.jsp").forward(req, resp);

            req.getSession().removeAttribute("f_code");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("/run".equals(req.getPathInfo())) {
            problemService.run(req,resp);

        }else {
//            resp.sendRedirect("/problem?id=" + id + "&run=" + true);
        }
    }
}
