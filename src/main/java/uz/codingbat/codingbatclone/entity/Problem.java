package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;
import uz.codingbat.codingbatclone.entity.enums.Difficulty;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
public class Problem {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String title;

    @Enumerated(EnumType.STRING)
    private Difficulty difficulty;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String codeTemplate;

    @OneToMany(mappedBy = "problem", cascade = CascadeType.ALL)
    private Set<TestCase> testCases = new HashSet<>();

    @OneToMany(mappedBy = "problem", cascade = CascadeType.ALL)
    private Set<Solution> solutions = new HashSet<>();
}
