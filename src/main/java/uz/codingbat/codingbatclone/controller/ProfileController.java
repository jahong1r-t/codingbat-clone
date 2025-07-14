package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.service.ProfileService;

import java.io.IOException;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
    private final ProfileService profileService = ProfileService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isSessionValid(req)) {
            profileService.getProfile(req, resp);
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (isSessionValid(req)) {
            profileService.updateProfile(req, resp);
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }
}
