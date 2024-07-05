package com.opencbs.core.configs;
import java.sql.Connection;

import javax.persistence.EntityManagerFactory;
import javax.persistence.PersistenceUnit;

import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.MigrationInfo;
import org.flywaydb.core.api.callback.FlywayCallback;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FlywayCallbackConfig {

    @PersistenceUnit
    private EntityManagerFactory entityManagerFactory;

    @Autowired
    private Flyway flyway;

    @Bean
    public FlywayCallback flywayCallback() {
        return new FlywayCallback() {
            public void beforeClean(Flyway flyway) {
                // No implementation needed
            }

            public void afterClean(Flyway flyway) {
                // No implementation needed
            }

            public void beforeMigrate(Flyway flyway) {
                // No implementation needed
            }

            public void afterMigrate(Flyway flyway) {
                // Initialize Hibernate to create Envers auditing tables
                entityManagerFactory.createEntityManager();
            }

            public void beforeEachMigrate(Flyway flyway) {
                // No implementation needed
            }

            public void afterEachMigrate(Flyway flyway) {
                // No implementation needed
            }

            public void beforeValidate(Flyway flyway) {
                // No implementation needed
            }

            public void afterValidate(Flyway flyway) {
                // No implementation needed
            }

            public void beforeBaseline(Flyway flyway) {
                // No implementation needed
            }

            public void afterBaseline(Flyway flyway) {
                // No implementation needed
            }

            public void beforeRepair(Flyway flyway) {
                // No implementation needed
            }

            public void afterRepair(Flyway flyway) {
                // No implementation needed
            }

            public void beforeInfo(Flyway flyway) {
                // No implementation needed
            }

            public void afterInfo(Flyway flyway) {
                // No implementation needed
            }

			@Override
			public void beforeClean(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterClean(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void beforeMigrate(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterMigrate(Connection connection) {
				entityManagerFactory.createEntityManager();
				
			}

			@Override
			public void beforeEachMigrate(Connection connection, MigrationInfo info) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterEachMigrate(Connection connection, MigrationInfo info) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void beforeValidate(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterValidate(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void beforeBaseline(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterBaseline(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void beforeRepair(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterRepair(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void beforeInfo(Connection connection) {
				// TODO Auto-generated method stub
				
			}

			@Override
			public void afterInfo(Connection connection) {
				// TODO Auto-generated method stub
				
			}
        };
    }
}
