# SQL for Creating the `audit_logs` Table

This setup ensures that your `audit_logs` table is robust, efficient, and ready to store detailed logs of all database changes, providing valuable insights and audit trails for your application.

```sql
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
```

### Explanation of Table Structure:

1. **id**: A unique identifier for each log entry. It is auto-incremented to ensure uniqueness.
2. **dtime**: The datetime when the log was recorded. It defaults to the current timestamp at the time of logging.
3. **table_name**: The name of the table where the modification occurred. This helps in filtering logs by table.
4. **action**: The type of action that was performed. This is stored as an enum for better performance compared to strings and ensures that only valid actions are recorded.
5. **json_log**: A JSON object containing a detailed snapshot of the data modified during the operation. Using JSON allows flexibility to accommodate tables with different structures without altering the log schema.
6. **created_at**: Timestamp indicating when the log record was created. Although similar to `dtime`, it ensures there's a system-generated timestamp that isn't dependent on the trigger’s execution.

### Considerations for Optimization:

- **Indexes**: Depending on the query patterns, you might want to add indexes. Common queries might include searching by `table_name`, `action`, or `dtime`. Indexing these columns can significantly improve search performance.
- **Partitioning**: For very large datasets, consider partitioning the `audit_logs` table by time (e.g., monthly or yearly). This can improve performance and manageability.
- **Cleanup Policy**: Implement a data retention policy to periodically purge old entries from the `audit_logs` table to keep the size manageable and maintain performance.
