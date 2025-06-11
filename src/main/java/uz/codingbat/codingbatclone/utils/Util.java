package uz.codingbat.codingbatclone.utils;

import jakarta.servlet.http.HttpServletRequest;

public interface Util {

    static boolean isValidEmail(String email) {
        return email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$");
    }

    static boolean isValidPassword(String password) {
        return password == null || password.length() < 6;
    }

    static boolean isValidFullName(String fullName) {
        return fullName != null && fullName.trim().split("\\s+").length >= 2;
    }

    static boolean isSessionValid(HttpServletRequest req) {
        Object id = req.getSession().getAttribute("is_authenticated");
        return id != null && id.toString() != null && !id.toString().isEmpty();
    }
}
