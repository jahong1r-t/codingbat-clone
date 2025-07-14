package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.service.ProblemService;

import java.io.IOException;

@WebServlet("/problem/*")
public class ProblemController extends HttpServlet {
    private final ProblemService problemService = new ProblemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        problemService.getProblem(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("/run".equals(req.getPathInfo())) {
            problemService.run(req, resp);
        } else {
//            resp.sendRedirect("/problem?id=" + id + "&run=" + true);
        }
    }
}
