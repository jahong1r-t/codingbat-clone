package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;

import java.util.Map;
import java.util.UUID;

@Data
@Builder
public class UserDTO {
    private UUID id;
    private String fullName;
    private String email;
    private String password;
    private Integer solvedProblemsCount;
    private Integer currentStreak;
    private Integer bestStreak;
    private Map<String, Integer> activity;
}
