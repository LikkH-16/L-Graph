package com.lgraph.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.neo4j.config.EnableNeo4jAuditing;

@Configuration
@EnableNeo4jAuditing
public class Neo4jConfig {
    // Neo4j auto-configuration is handled by Spring Boot
    // Graph nodes and relationships are managed via Spring Data Neo4j repositories
}
