package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
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

    private boolean passed;

    private LocalDateTime submittedAt;
}

