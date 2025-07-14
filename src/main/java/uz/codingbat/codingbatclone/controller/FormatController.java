package uz.codingbat.codingbatclone.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.SneakyThrows;
import uz.codingbat.codingbatclone.payload.CacheDTO;
import uz.codingbat.codingbatclone.service.CompileService;

import java.util.HashMap;
import java.util.Map;

@WebServlet("/format")
public class FormatController extends HttpServlet {
    private final CompileService compileService = CompileService.getInstance();

    @Override
    @SneakyThrows
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        Map<String, CacheDTO> cache = (Map<String, CacheDTO>) req.getSession().getAttribute("cache");
        String id = req.getParameter("id");

        String code = compileService.formatCode(req.getParameter("code"));

        if (cache == null) {
            cache = new HashMap<>();
            CacheDTO cacheDTO = CacheDTO.builder()
                    .code(code)
                    .build();
            cache.put(id, cacheDTO);
        } else {
            cache.get(id).setCode(code);
        }

        resp.sendRedirect("/problem?id=" + req.getParameter("id"));
    }
}
