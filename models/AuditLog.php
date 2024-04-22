<?php
// Path: /app/Models/AuditLog.php
// Laravel Model
// Filename: AuditLog.php
// Type: Model
// Structure Number: 1
// Iteration Number: 1
// Coding Level: B

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class AuditLog extends Model
{
    protected $table = 'audit_logs';

    protected $fillable = ['dtime', 'table_name', 'action', 'json_log', 'created_at'];

    public $timestamps = false; // assuming created_at is managed by the database
}
