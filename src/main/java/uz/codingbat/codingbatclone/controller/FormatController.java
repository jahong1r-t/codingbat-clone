package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.service.CompileService;

import java.io.IOException;

@WebServlet("/format")
public class FormatController extends HttpServlet {
    private final CompileService compileService = new CompileService();

    @Override
    @SneakyThrows
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().setAttribute("f_code", compileService.formatCode(req.getParameter("code")));

        resp.sendRedirect("/problem?id=" + req.getParameter("id"));
    }
}
