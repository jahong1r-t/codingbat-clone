package uz.codingbat.codingbatclone.payload;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class StatsDTO {
    private Long totalUsers;
    private Long totalProblems;
    private String  latestProblem;
    private String  mostSolved;
}
