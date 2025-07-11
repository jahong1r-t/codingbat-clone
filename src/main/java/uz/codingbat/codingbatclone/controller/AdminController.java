package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.entity.enums.Role;

import java.io.IOException;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isSessionValid(req)) {
            System.err.println(req.getSession().getAttribute("role"));
            if (req.getSession().getAttribute("role") == Role.ADMIN) {
                req.getRequestDispatcher("admin.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("/profile");
            }
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }
}
