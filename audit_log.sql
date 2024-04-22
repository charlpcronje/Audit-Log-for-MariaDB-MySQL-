-- Path: /database/tables/create_audit_logs.sql
-- Filename: create_audit_logs.sql
-- Type: Table Creation Script
-- Structure Number: 1
-- Iteration Number: 1
-- Coding Level: B

CREATE TABLE audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dtime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    table_name VARCHAR(64) NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    json_log JSON NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
