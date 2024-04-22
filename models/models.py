# Path: /app/models.py
# Filename: models.py
# Type: Model
# Structure Number: 3
# Iteration Number: 1
# Coding Level: B

from django.db import models
import json

class AuditLog(models.Model):
    dtime = models.DateTimeField(auto_now_add=True)
    table_name = models.CharField(max_length=64)
    action = models.CharField(max_length=10, choices=[('INSERT', 'Insert'), ('UPDATE', 'Update'), ('DELETE', 'Delete')])
    json_log = models.JSONField()
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'audit_logs'
