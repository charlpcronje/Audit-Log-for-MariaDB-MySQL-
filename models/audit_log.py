# Path: /app/models/audit_log.py
# Filename: audit_log.py
# Type: Model
# Structure Number: 2
# Iteration Number: 1
# Coding Level: B

from sqlalchemy import Column, Integer, String, DateTime, JSON, Enum
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class AuditLog(Base):
    __tablename__ = 'audit_logs'
    id = Column(Integer, primary_key=True, autoincrement=True)
    dtime = Column(DateTime, default=datetime.datetime.utcnow)
    table_name = Column(String(64))
    action = Column(Enum('INSERT', 'UPDATE', 'DELETE'))
    json_log = Column(JSON)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
