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
