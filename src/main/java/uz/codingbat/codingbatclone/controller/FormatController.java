package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.service.CompileService;

@WebServlet("/format")
public class FormatController extends HttpServlet {
    private final CompileService compileService = CompileService.getInstance();

    @Override
    @SneakyThrows
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        req.getSession().setAttribute("f_code", compileService.formatCode(req.getParameter("code")));

        resp.sendRedirect("/problem?id=" + req.getParameter("id"));
    }
}
