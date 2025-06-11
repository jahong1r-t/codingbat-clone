package uz.codingbat.codingbatclone.service;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import uz.codingbat.codingbatclone.db.JpaConnection;

import java.util.UUID;

@RequiredArgsConstructor
public class CompileService {

    public String formatCode(String code) throws FormatterException {
        try {
            Formatter formatter = new Formatter();
            return formatter.formatSource(code);
        } catch (FormatterException e) {
            return code;
        }
    }

    public void compile(String code, UUID problemId) throws FormatterException {
    }
}
