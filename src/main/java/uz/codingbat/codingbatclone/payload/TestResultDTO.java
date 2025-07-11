package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TestResultDTO {
    private String input;
    private String output;
    private String yourOutput;
}
