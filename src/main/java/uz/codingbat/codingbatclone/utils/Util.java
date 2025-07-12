package uz.codingbat.codingbatclone.utils;

import jakarta.servlet.http.HttpServletRequest;
import uz.codingbat.codingbatclone.entity.User;

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
        Object id = req.getSession().getAttribute("user_id");
        return id != null && id.toString() != null && !id.toString().isEmpty();
    }

    static User getUser(HttpServletRequest req) {
        return (User) req.getSession().getAttribute("user");
    }
}
