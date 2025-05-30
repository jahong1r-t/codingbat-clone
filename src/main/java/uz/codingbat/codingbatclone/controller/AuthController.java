package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.service.AuthService;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthController extends HttpServlet {
    private final AuthService authService = AuthService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("/signin".equals(req.getPathInfo())) {
            authService.signIn(req, resp);
        } else if ("/signup".equals(req.getPathInfo())) {
            authService.signUp(req, resp);
        } else if ("/logout".equals(req.getPathInfo())) {
            authService.logOut(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Path not found: " + req.getPathInfo());
        }
    }
}
