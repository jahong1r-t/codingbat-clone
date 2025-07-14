package uz.codingbat.codingbatclone.payload;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TestCaseDTO {
    private String input;
    private String output;
    private boolean hidden;

    @JsonCreator
    public TestCaseDTO(
            @JsonProperty("input") String input,
            @JsonProperty("output") String output,
            @JsonProperty("hidden") boolean hidden) {
        this.input = input;
        this.output = output;
        this.hidden = hidden;
    }
}
