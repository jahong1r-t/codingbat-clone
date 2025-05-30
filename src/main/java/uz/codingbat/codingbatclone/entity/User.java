package uz.codingbat.codingbatclone.entity;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String fullName;
    private String email;
    private String password;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private Set<Solution> solutions = new HashSet<>();
}

