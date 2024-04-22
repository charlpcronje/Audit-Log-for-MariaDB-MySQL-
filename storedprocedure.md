# Complete Stored Procedure for Automatic Trigger Creation

## Change Log
- Trigger Existence Check: Before attempting to create a trigger for a table, the procedure now checks if a trigger with the same name already exists. This check is done by querying the information_schema.triggers for each trigger type (INSERT, UPDATE, DELETE).
- Conditional Trigger Creation: The procedure only attempts to create a trigger if it does not already exist. This conditional creation prevents errors related to duplicate triggers.
- Dynamic SQL Preparation and Execution: The procedure constructs, prepares, and executes SQL statements conditionally based on the existence of triggers.

```sql
-- Path: /database/procedures/setup_audit_triggers_safe_run.sql
-- Filename: setup_audit_triggers_safe_run.sql
-- Type: Stored Procedure
-- Structure Number: 3
-- Iteration Number: 3
-- Coding Level: A+

DELIMITER $$

CREATE PROCEDURE SetupAuditTriggers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tableName VARCHAR(255);
    DECLARE cur CURSOR FOR SELECT table_name FROM information_schema.tables WHERE table_schema = 'YourDatabaseName'; -- Replace 'YourDatabaseName' with your actual database name
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tableName;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Check and create trigger for INSERT
        IF NOT EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_schema = 'YourDatabaseName' AND trigger_name = CONCAT(tableName, '_after_insert')) THEN
            SET @sql_insert = CONCAT('
                CREATE TRIGGER ', tableName, '_after_insert
                AFTER INSERT ON ', tableName, '
                FOR EACH ROW
                BEGIN
                    INSERT INTO audit_logs (dtime, table_name, action, json_log, created_at)
                    VALUES (NOW(), ''', tableName, ''', ''INSERT'', JSON_OBJECT(
                        ', (SELECT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME, '\'', ', NEW.', COLUMN_NAME, ' AS ''', COLUMN_NAME, '''')) FROM information_schema.columns WHERE table_name = ''', tableName, ''' AND table_schema = ''YourDatabaseName''), '
                    ), NOW());
                END;
            ');
            PREPARE stmt_insert FROM @sql_insert;
            EXECUTE stmt_insert;
            DEALLOCATE PREPARE stmt_insert;
        END IF;

        -- Check and create trigger for UPDATE
        IF NOT EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_schema = 'YourDatabaseName' AND trigger_name = CONCAT(tableName, '_after_update')) THEN
            SET @sql_update = CONCAT('
                CREATE TRIGGER ', tableName, '_after_update
                AFTER UPDATE ON ', tableName, '
                FOR EACH ROW
                BEGIN
                    INSERT INTO audit_logs (dtime, table_name, action, json_log, created_at)
                    VALUES (NOW(), ''', tableName, ''', ''UPDATE'', JSON_OBJECT(
                        ', (SELECT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME, '\'', ', NEW.', COLUMN_NAME, ' AS ''', COLUMN_NAME, '''')) FROM information_schema.columns WHERE table_name = ''', tableName, ''' AND table_schema = ''YourDatabaseName''), '
                    ), NOW());
                END;
            ');
            PREPARE stmt_update FROM @sql_update;
            EXECUTE stmt_update;
            DEALLOCATE PREPARE stmt_update;
        END IF;

        -- Check and create trigger for DELETE
        IF NOT EXISTS (SELECT 1 FROM information_schema.triggers WHERE trigger_schema = 'YourDatabaseName' AND trigger_name = CONCAT(tableName, '_after_delete')) THEN
            SET @sql_delete = CONCAT('
                CREATE TRIGGER ', tableName, '_after_delete
                AFTER DELETE ON ', tableName, '
                FOR EACH ROW
                BEGIN
                    INSERT INTO audit_logs (dtime, table_name, action, json_log, created_at)
                    VALUES (NOW(), ''', tableName, ''', ''DELETE'', JSON_OBJECT(
                        ', (SELECT GROUP_CONCAT(CONCAT('\'', COLUMN_NAME, '\'', ', OLD.', COLUMN_NAME, ' AS ''', COLUMN_NAME, '''')) FROM information_schema.columns WHERE table_name = ''', tableName, ''' AND table_schema = ''YourDatabaseName''), '
                    ), NOW());
                END;
            ');
            PREPARE stmt_delete FROM @sql_delete;
            EXECUTE stmt_delete;
            DEALLOCATE PREPARE stmt_delete;
        END IF;

    END LOOP;

    CLOSE cur;
END$$

DELIMITER ;

```

## Detailed Comments:
1. **Delimiters**: The `DELIMITER $$` changes the standard command delimiter from `;` to `$$` to allow the `;` to be used within the procedure.
2. **Cursor Setup**: Sets up a cursor to loop through all tables in the specified database.
3. **Error Handling**: A continue handler is set up to manage the end of the cursor loop gracefully.
4. **Loop through Tables**: The procedure loops through each table, creating three triggers: one for each of INSERT, UPDATE, and DELETE.
5. **Trigger Creation**: For each operation type, the procedure dynamically constructs an SQL string for trigger creation, which includes:
    - **JSON_OBJECT Function**: Constructs a JSON object from all column values of the affected row, using `NEW` for INSERT/UPDATE and `OLD` for DELETE.
6. **Dynamic SQL Execution**: Each constructed SQL statement is prepared, executed, and then deallocated.
