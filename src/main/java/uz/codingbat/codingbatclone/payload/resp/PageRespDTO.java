package uz.codingbat.codingbatclone.payload.resp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class PageRespDTO<T> {
    private List<?> content;
    private int size;
    private int currentPage;
    private int totalPages;
    private int nextPage;
    private int previousPage;
    private long totalElements;
    private String filter;
}
