package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.entity.enums.Role;
import uz.codingbat.codingbatclone.service.AdminService;

import java.io.IOException;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private final AdminService adminService = AdminService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (isSessionValid(req)) {
            if (req.getSession().getAttribute("role") == Role.ADMIN) {
                adminService.admin(req, resp);
            } else {
                resp.sendRedirect("/profile");
            }
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    }
}
