package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TestResultSummaryDTO {
    private Integer passed;
    private Integer failed;
    private Integer error;
    private String code;
    private List<TestResultDTO> details;
}
