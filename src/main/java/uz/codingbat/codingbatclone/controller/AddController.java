package uz.codingbat.codingbatclone.controller;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import uz.codingbat.codingbatclone.entity.enums.Role;
import uz.codingbat.codingbatclone.payload.ProblemRespDTO;
import uz.codingbat.codingbatclone.payload.TestCaseDTO;
import uz.codingbat.codingbatclone.service.ProblemService;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;

import static uz.codingbat.codingbatclone.utils.Util.isSessionValid;

@WebServlet("/add")
public class AddController extends HttpServlet {
    private final ProblemService problemService = new ProblemService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (isSessionValid(req) && req.getSession().getAttribute("role") == Role.ADMIN) {
            req.getRequestDispatcher("add.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("/auth?tab=signin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set response type to JSON
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            // 1. Read JSON data
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            // Log raw JSON for debugging
            System.out.println("Received JSON:");
            System.out.println(jsonBuilder.toString());

            // 2. Parse JSON
            ObjectMapper objectMapper = new ObjectMapper();
            ProblemRespDTO problemRespDTO = objectMapper.readValue(jsonBuilder.toString(), ProblemRespDTO.class);

            // 3. Validate main problem fields
            if (problemRespDTO.getTitle() == null || problemRespDTO.getTitle().trim().isEmpty()) {
                throw new IllegalArgumentException("Problem title is required");
            }

            if (problemRespDTO.getDescription() == null || problemRespDTO.getDescription().trim().isEmpty()) {
                throw new IllegalArgumentException("Description is required");
            }
            if (problemRespDTO.getCodeTemplate() == null || problemRespDTO.getCodeTemplate().trim().isEmpty()) {
                throw new IllegalArgumentException("Code template is required");
            }
            if (problemRespDTO.getTestCases() == null || problemRespDTO.getTestCases().isEmpty()) {
                throw new IllegalArgumentException("At least one test case is required");
            }

            // 4. Validate test cases
            for (int i = 0; i < problemRespDTO.getTestCases().size(); i++) {
                TestCaseDTO testCase = problemRespDTO.getTestCases().get(i);
                if (testCase.getInput() == null || testCase.getInput().trim().isEmpty()) {
                    throw new IllegalArgumentException("Input for test case #" + (i+1) + " cannot be empty");
                }
                if (testCase.getOutput() == null || testCase.getOutput().trim().isEmpty()) {
                    throw new IllegalArgumentException("Output for test case #" + (i+1) + " cannot be empty");
                }
            }

            // 5. Log received data
            System.out.println("\nParsed Problem Data:");
            System.out.println("Title: " + problemRespDTO.getTitle());
            System.out.println("Difficulty: " + problemRespDTO.getDifficulty());
            System.out.println("Description: " + problemRespDTO.getDescription().substring(0, Math.min(50, problemRespDTO.getDescription().length())) + "...");
            System.out.println("Code Template: " + problemRespDTO.getCodeTemplate().substring(0, Math.min(50, problemRespDTO.getCodeTemplate().length())) + "...");

            System.out.println("\nTest Cases:");
            for (int i = 0; i < problemRespDTO.getTestCases().size(); i++) {
                TestCaseDTO testCase = problemRespDTO.getTestCases().get(i);
                System.out.println("  Test Case #" + (i+1));
                System.out.println("    Input: " + testCase.getInput());
                System.out.println("    Output: " + testCase.getOutput());
                System.out.println("    Hidden: " + (testCase.isHidden() ? "Yes" : "No"));
            }

            // 6. Return success response
            out.write("{\"status\":\"success\", \"message\":\"Problem received successfully\"}");
            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (JsonProcessingException e) {
            // JSON parsing error
            System.err.println("JSON parsing error: " + e.getMessage());
            out.write("{\"status\":\"error\", \"message\":\"Invalid JSON format: " + e.getMessage().replace("\"", "'") + "\"}");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        } catch (IllegalArgumentException e) {
            // Validation error
            System.err.println("Validation error: " + e.getMessage());
            out.write("{\"status\":\"error\", \"message\":\"" + e.getMessage().replace("\"", "'") + "\"}");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);

        } catch (Exception e) {
            // Other errors
            System.err.println("Server error: " + e.getMessage());
            out.write("{\"status\":\"error\", \"message\":\"Server error: " + e.getMessage().replace("\"", "'") + "\"}");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }}
