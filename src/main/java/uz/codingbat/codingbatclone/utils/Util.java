package uz.codingbat.codingbatclone.utils;

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
}
