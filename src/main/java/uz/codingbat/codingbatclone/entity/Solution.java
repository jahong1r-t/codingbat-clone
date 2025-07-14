package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;
import lombok.*;
import uz.codingbat.codingbatclone.entity.enums.SolveStatus;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Solution {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "problem_id")
    private Problem problem;

    @Column(columnDefinition = "TEXT")
    private String code;

    private SolveStatus solveStatus;

    private LocalDateTime submittedAt;
}

