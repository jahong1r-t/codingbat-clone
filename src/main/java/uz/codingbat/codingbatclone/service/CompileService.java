package uz.codingbat.codingbatclone.service;

import com.google.googlejavaformat.java.Formatter;
import com.google.googlejavaformat.java.FormatterException;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.db.JpaConnection;
import uz.codingbat.codingbatclone.entity.TestCase;
import uz.codingbat.codingbatclone.payload.TestResultDTO;
import uz.codingbat.codingbatclone.payload.TestSummaryDTO;

import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@RequiredArgsConstructor
public class CompileService {
    private static CompileService instance;
    private final JpaConnection jpaConnection = JpaConnection.getInstance();

    public String formatCode(String code) {
        try {
            Formatter formatter = new Formatter();
            return formatter.formatSource(code);
        } catch (FormatterException e) {
            return code;
        }
    }


    @SneakyThrows
    public Map<TestCase, String> compile(String code, String id) {
        Map<TestCase, String> results = new LinkedHashMap<>();
        Path baseDir = Paths.get("D:/Git Hub/codingbat-clone/src/temp");
        Path userDir = Files.createDirectories(baseDir.resolve(UUID.randomUUID().toString()));

        try (EntityManager entityManager = jpaConnection.entityManager()) {
            UUID uuid = UUID.fromString(id);
            List<TestCase> testCases = entityManager
                    .createQuery("select t from TestCase t join fetch t.problem where t.problem.id = :id", TestCase.class)
                    .setParameter("id", uuid)
                    .getResultList();

            code = makeMethodStaticIfNeeded(code);
            String className = extractClassName(code);
            Path solutionFile = userDir.resolve(className + ".java");
            Files.writeString(solutionFile, code);

            String methodName = extractMethodName(code);
            List<String> runnerClassNames = new ArrayList<>();

            for (int i = 0; i < testCases.size(); i++) {
                TestCase test = testCases.get(i);
                String runnerClassName = "TestRunner" + i;
                runnerClassNames.add(runnerClassName);

                String testCode = String.format("""
                                public class %s {
                                    public static void main(String[] args) {
                                        try {
                                            Object result = %s.%s("%s");
                                            System.out.println(result.equals("%s") ? "PASS" : "FAIL: expected %s but was " + result);
                                        } catch (Exception e) {
                                            System.out.println("EXCEPTION: " + e.getMessage());
                                        }
                                    }
                                }
                                """,
                        runnerClassName,
                        className,
                        methodName,
                        test.getInput().replace("\"", "\\\""),
                        test.getOutput().replace("\"", "\\\""),
                        test.getOutput().replace("\"", "\\\"")
                );

                Files.writeString(userDir.resolve(runnerClassName + ".java"), testCode);
            }

            JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
            List<String> filesToCompile = new ArrayList<>();
            filesToCompile.add(solutionFile.toString());

            for (String name : runnerClassNames) {
                filesToCompile.add(userDir.resolve(name + ".java").toString());
            }

            int compilationResult = compiler.run(null, null, null, filesToCompile.toArray(new String[0]));
            if (compilationResult != 0) {
                testCases.forEach(tc -> results.put(tc, "COMPILATION ERROR"));
                return results;
            }

            for (int i = 0; i < testCases.size(); i++) {
                TestCase testCase = testCases.get(i);
                String runnerClassName = "TestRunner" + i;

                Process process = new ProcessBuilder("java", "-cp", userDir.toString(), runnerClassName)
                        .directory(userDir.toFile())
                        .redirectErrorStream(true)
                        .start();

                boolean finished = process.waitFor(2, TimeUnit.SECONDS);
                if (!finished) {
                    process.destroyForcibly();
                    results.put(testCase, "TIMEOUT");
                    continue;
                }

                String output = new BufferedReader(new InputStreamReader(process.getInputStream()))
                        .lines().collect(Collectors.joining("\n"));

                results.put(testCase, output);
            }

            return results;
        } finally {
            deleteDir(userDir);
        }
    }

    private String extractMethodName(String code) {
        Pattern pattern = Pattern.compile("\\b(public|private|protected)\\s+(static\\s+)?\\w+\\s+(\\w+)\\s*\\(");
        Matcher matcher = pattern.matcher(code);
        if (matcher.find()) {
            return matcher.group(3);
        }
        return "unknownMethod";
    }

    private String extractClassName(String code) {
        Pattern pattern = Pattern.compile("public\\s+class\\s+(\\w+)");
        Matcher matcher = pattern.matcher(code);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return "Solution";
    }

    private String makeMethodStaticIfNeeded(String code) {
        Pattern methodPattern = Pattern.compile(
                "(public|protected|private)\\s+(?!static)([\\w<>\\[\\]]+\\s+)(\\w+)\\s*\\(([^)]*)\\)\\s*\\{");
        Matcher matcher = methodPattern.matcher(code);

        StringBuilder sb = new StringBuilder();
        while (matcher.find()) {
            String replacement = matcher.group(1) + " static " + matcher.group(2) + matcher.group(3) + "(" + matcher.group(4) + ") {";
            matcher.appendReplacement(sb, replacement);
        }
        matcher.appendTail(sb);
        return sb.toString();
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

    public TestSummaryDTO summarizeTestResults(Map<TestCase, String> results, String code) {
        int passed = 0, failed = 0, error = 0;
        List<TestResultDTO> details = new ArrayList<>();

        for (Map.Entry<TestCase, String> entry : results.entrySet()) {
            TestCase test = entry.getKey();
            String output = entry.getValue();

            String yourOutput;
            if (output.startsWith("PASS")) {
                passed++;
                yourOutput = test.getOutput();
            } else if (output.startsWith("FAIL")) {
                failed++;
                yourOutput = output.substring(output.lastIndexOf("was") + 4);
            } else {
                error++;
                yourOutput = output;
            }

            details.add(TestResultDTO.builder()
                    .input(test.getInput())
                    .output(test.getOutput())
                    .yourOutput(yourOutput)
                    .build());
        }

        return TestSummaryDTO.builder()
                .passed(passed)
                .failed(failed)
                .error(error)
                .code(code)
                .details(details)
                .build();
    }

    public static CompileService getInstance() {
        if (instance == null) {
            instance = new CompileService();
        }

        return instance;
    }
}
