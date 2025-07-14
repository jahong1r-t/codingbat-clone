package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;

@EqualsAndHashCode(callSuper = true)
@Entity
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserStats extends Auditable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Integer solvedProblemsCount;

    private Integer currentStreak;

    private Integer bestStreak;

    private LocalDate lastSolvedDate;

    @OneToOne
    private User user;

}
