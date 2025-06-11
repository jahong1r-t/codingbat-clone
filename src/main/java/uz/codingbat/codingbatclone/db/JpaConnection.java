package uz.codingbat.codingbatclone.db;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaConnection {
    private static final EntityManagerFactory entityManagerFactory =
            Persistence.createEntityManagerFactory("codingbat-orm");

    private static final JpaConnection jpaConnection = new JpaConnection();

    private JpaConnection() {
    }

    public static JpaConnection getInstance() {
        return jpaConnection;
    }

    public EntityManager entityManager() {
        return entityManagerFactory.createEntityManager();
    }
}
