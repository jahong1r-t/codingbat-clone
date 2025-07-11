package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;
import lombok.*;

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

    @OneToOne
    private User user;

}
