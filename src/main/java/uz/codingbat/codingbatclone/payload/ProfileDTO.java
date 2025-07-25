package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;
import uz.codingbat.codingbatclone.entity.enums.Role;

import java.time.LocalDate;
import java.util.Map;
import java.util.UUID;

@Data
@Builder
public class ProfileDTO {
    private UUID id;
    private String fullName;
    private String email;
    private String password;
    private Role role;
    private Integer solvedProblemsCount;
    private Integer currentStreak;
    private Integer bestStreak;
    private Map<LocalDate, Integer> activity;
}
