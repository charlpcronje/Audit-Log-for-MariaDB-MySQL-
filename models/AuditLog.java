// Path: /src/main/java/com/yourapp/model/AuditLog.java
// Filename: AuditLog.java
// Type: Model
// Structure Number: 5
// Iteration Number: 1
// Coding Level: B

package com.yourapp.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "audit_logs")
public class AuditLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Date dtime;

    @Column(nullable = false, length = 64)
    private String table_name;

    @Column(nullable = false)
    private String action;

    @Column(nullable = false, columnDefinition = "json")
    private String json_log;

    @Column(nullable = false)
    private Date created_at;
}
