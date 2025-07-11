package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;
import uz.codingbat.codingbatclone.entity.enums.Difficulty;

import java.util.List;
import java.util.UUID;

@Data
@Builder
public class ProblemDTO {
    private UUID id;
    private String title;
    private Difficulty difficulty;
    private String description;
    private String codeTemplate;
    private List<TestCaseDTO> testCases;
}
