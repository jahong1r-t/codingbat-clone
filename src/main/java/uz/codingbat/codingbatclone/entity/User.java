package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;
import lombok.*;
import uz.codingbat.codingbatclone.entity.enums.Role;

import java.util.*;

@Entity
@Table(name = "users")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String fullName;
    private String email;
    private String password;
    private int solvedProblemsCount;
    private int currentStreak;
    private int bestStreak;
    @Enumerated(EnumType.STRING)
    private Role role;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Solution> solutions = new ArrayList<>();
}

