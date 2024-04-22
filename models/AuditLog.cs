// Path: /Models/AuditLog.cs
// Filename: AuditLog.cs
// Type: Model
// Structure Number: 6
// Iteration Number: 1
// Coding Level: B

using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace YourApp.Models
{
    [Table("audit_logs")]
    public class AuditLog
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public long Id { get; set; }

        [Required]
        public DateTime Dtime { get; set; }

        [Required]
        [StringLength(64)]
        public string TableName { get; set; }

        [Required]
        public string Action { get; set; }

        [Required]
        public string JsonLog { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; }
    }
}
