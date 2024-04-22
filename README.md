# Audit Log for MariaDB & MySQL Databases
This stored procedure is designed to automatically create database triggers for `INSERT`, `UPDATE`, and `DELETE` operations across all tables in a specified MariaDB database. These triggers log changes to an `audit_logs` table, capturing detailed information about data modifications in JSON format. The procedure ensures that each table has its corresponding triggers without duplications, making it safe to rerun whenever new tables are added.

### Files in Repo
- [README.md](./README.md)
- [storedProcedure.sql](./storedProcedure.sql)
- [storedprocedure.md](./storedprocedure.md)
- [audit_log.sql](./audit_log.sql)
- [audit_log.md](./audit_log.md)

### How It Works

#### Procedure Logic
1. **Database Iteration**: The procedure iterates over all tables in the specified database.
2. **Existence Checks**: For each table, it checks if specific triggers (`INSERT`, `UPDATE`, `DELETE`) already exist.
3. **Conditional Trigger Creation**: If a trigger does not exist, it is created. Each trigger logs modifications to the `audit_logs` table, including:
   - `dtime`: The date and time of the log entry.
   - `table_name`: The name of the table where the change occurred.
   - `action`: The type of action (`INSERT`, `UPDATE`, `DELETE`).
   - `json_log`: A JSON object containing all column values involved in the transaction.
   - `created_at`: The timestamp when the log entry was created.

#### Technical Details
- **Dynamic SQL**: The procedure uses dynamic SQL for trigger creation to accommodate various table structures dynamically.
- **Safety Checks**: It includes checks to avoid creating duplicate triggers, allowing the procedure to be run multiple times safely.
- **JSON Data Handling**: The JSON object is dynamically constructed based on the table's columns, ensuring comprehensive logging.

### Setup Instructions
1. **Modify the Database Name**: Replace `'YourDatabaseName'` in the script with the actual name of your database.
2. **Execute the Procedure**: Run the stored procedure script in your MariaDB environment to deploy it.
3. **Run the Procedure**: Execute the procedure using `CALL SetupAuditTriggers();` to create the triggers.

### Potential Upgrades
- **Enhanced Error Handling**: Incorporate detailed error handling to manage issues that might arise during trigger creation, such as permission problems or SQL syntax errors.
- **Performance Optimization**: Implement batching or asynchronous processing to reduce the load on the database when multiple triggers are being created simultaneously.
- **Customizable Logging Details**: Add parameters to the procedure allowing customization of which data points are logged, or handling different data types more gracefully.
- **Security Features**: Include options for masking or encrypting sensitive data within the logs.

### Recommended Storage Engine for the Log Table
- **InnoDB**: Recommended for the `audit_logs` table due to its support for ACID transactions, row-level locking, and crash recovery. InnoDB’s performance and reliability make it suitable for handling frequent inserts generated by the triggers.

### Conclusion
This automated trigger creation procedure facilitates comprehensive auditing across all database tables. It is ideal for maintaining a detailed change log, aiding in debugging, monitoring, and compliance with regulatory requirements.

---

This `README.md` provides a complete guide to deploying and understanding the stored procedure, ensuring users can implement and potentially modify the procedure according to specific needs. If you have additional requirements or questions about this documentation, please let me know!
