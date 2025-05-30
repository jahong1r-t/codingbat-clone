package uz.codingbat.codingbatclone.db;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JpaConnection {
    private static EntityManagerFactory entityManagerFactory;
    private static JpaConnection jpaConnection;

    public EntityManager entityManager() {
        if (entityManagerFactory == null) {
            entityManagerFactory = Persistence.createEntityManagerFactory("codingbat-orm");
        }
        return entityManagerFactory.createEntityManager();
    }

    public static JpaConnection getInstance() {
        if (jpaConnection == null) {
            jpaConnection = new JpaConnection();
        }
        return jpaConnection;
    }
}
