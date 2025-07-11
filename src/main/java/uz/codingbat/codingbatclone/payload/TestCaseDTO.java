package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TestCaseDTO {
    private String input;
    private String output;
    private boolean hidden;
}
