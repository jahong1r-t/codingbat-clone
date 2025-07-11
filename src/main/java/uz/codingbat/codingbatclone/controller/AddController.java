package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.entity.enums.Role;

import java.io.IOException;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/add")
public class AddController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isSessionValid(req)) {
            if (req.getSession().getAttribute("role") == Role.ADMIN) {
                req.setAttribute("role", Role.ADMIN);
                req.getRequestDispatcher("add.jsp").forward(req, resp);
            }else {
                resp.sendRedirect("/");
            }
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }
}
