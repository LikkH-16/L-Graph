-- L-Graph Database Schema
-- MySQL 8.0

CREATE DATABASE IF NOT EXISTS lgraph DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SET NAMES utf8mb4;
USE lgraph;

-- User table
CREATE TABLE IF NOT EXISTS lgraph_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    avatar_url VARCHAR(500),
    deleted TINYINT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Subject table
CREATE TABLE IF NOT EXISTS lgraph_subject (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    parent_id BIGINT,
    order_index INT NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES lgraph_subject(id) ON DELETE SET NULL,
    INDEX idx_parent (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Knowledge node table
CREATE TABLE IF NOT EXISTS lgraph_knowledge_node (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject_id BIGINT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    parent_id BIGINT,
    level INT NOT NULL DEFAULT 0,
    order_index INT NOT NULL DEFAULT 0,
    node_type ENUM('CHAPTER', 'SECTION', 'TOPIC') NOT NULL DEFAULT 'TOPIC',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES lgraph_subject(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES lgraph_knowledge_node(id) ON DELETE CASCADE,
    INDEX idx_subject (subject_id),
    INDEX idx_parent (parent_id),
    INDEX idx_subject_level (subject_id, level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Note table
CREATE TABLE IF NOT EXISTS lgraph_note (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    metadata JSON,
    status ENUM('DRAFT', 'PUBLISHED') NOT NULL DEFAULT 'DRAFT',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES lgraph_user(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES lgraph_subject(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_subject (user_id, subject_id),
    INDEX idx_user (user_id),
    INDEX idx_subject (subject_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Page table
CREATE TABLE IF NOT EXISTS lgraph_page (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    note_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content LONGTEXT,
    order_index INT NOT NULL DEFAULT 0,
    review_round INT NOT NULL DEFAULT 0,
    mastery_level INT NOT NULL DEFAULT 0,
    last_reviewed_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES lgraph_note(id) ON DELETE CASCADE,
    INDEX idx_note (note_id),
    INDEX idx_note_order (note_id, order_index)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Page-KnowledgeNode junction table (M:N)
CREATE TABLE IF NOT EXISTS lgraph_page_knowledge_node (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    page_id BIGINT NOT NULL,
    knowledge_node_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (page_id) REFERENCES lgraph_page(id) ON DELETE CASCADE,
    FOREIGN KEY (knowledge_node_id) REFERENCES lgraph_knowledge_node(id) ON DELETE CASCADE,
    UNIQUE KEY uk_page_node (page_id, knowledge_node_id),
    INDEX idx_page (page_id),
    INDEX idx_node (knowledge_node_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Review record table
CREATE TABLE IF NOT EXISTS lgraph_review_record (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    page_id BIGINT NOT NULL,
    review_round INT NOT NULL DEFAULT 1,
    mastery_level INT NOT NULL DEFAULT 0,
    time_spent_seconds INT DEFAULT 0,
    notes VARCHAR(500),
    reviewed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES lgraph_user(id) ON DELETE CASCADE,
    FOREIGN KEY (page_id) REFERENCES lgraph_page(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_page (page_id),
    INDEX idx_user_page (user_id, page_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Mistake note table
CREATE TABLE IF NOT EXISTS lgraph_mistake_note (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    page_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    mistake_content TEXT,
    correct_solution TEXT,
    tags VARCHAR(500),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES lgraph_user(id) ON DELETE CASCADE,
    FOREIGN KEY (page_id) REFERENCES lgraph_page(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_page (page_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
