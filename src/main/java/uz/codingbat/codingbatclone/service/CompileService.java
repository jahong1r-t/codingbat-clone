package uz.codingbat.codingbatclone.service;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import jakarta.persistence.EntityManager;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.TestCase;


import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;
import java.util.stream.Stream;


@RequiredArgsConstructor
public class CompileService {
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public String formatCode(String code) throws FormatterException {
        try {
            Formatter formatter = new Formatter();
            return formatter.formatSource(code);
        } catch (FormatterException e) {
            return code;
        }
    }


    public void compile(HttpServletRequest req, HttpServletResponse resp) throws FormatterException, IOException {
        String code = req.getParameter("code");
        String id = req.getParameter("id");

        try (EntityManager entityManager = jpaConnection.entityManager()) {

        }
    }

    private String prepareTestCases(UUID id) {
        try (EntityManager entityManager = jpaConnection.entityManager()) {
            List<TestCase> cases = entityManager.createQuery("select t from TestCase t where t.problem.id= :id", TestCase.class)
                    .setParameter("id", id)
                    .getResultList();



            String testCode = """
                        public class TestRunner {
                            public static void main(String[] args) {
                                try {
                                    System.out.println(Solution.sum(2, 3) == 5 ? "PASS" : "FAIL");
                                    System.out.println(Solution.sum(-1, 1) == 0 ? "PASS" : "FAIL");
                                    System.out.println(Solution.sum(10, 20) == 30 ? "PASS" : "FAIL");
                                } catch (Exception e) {
                                    System.out.println("Exception: " + e.getMessage());
                                }
                            }
                        }
                    """;
        }

        return null;
    }


    private void deleteDir(Path dir) throws IOException {
        if (Files.exists(dir)) {
            try (Stream<Path> walk = Files.walk(dir)) {
                walk.sorted(Comparator.reverseOrder())
                        .map(Path::toFile)
                        .forEach(File::delete);
            }
        }
    }
}
