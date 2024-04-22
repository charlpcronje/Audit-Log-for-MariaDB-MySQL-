# Path: /app/models/audit_log.rb
# Filename: audit_log.rb
# Type: Model
# Structure Number: 4
# Iteration Number: 1
# Coding Level: B

class AuditLog < ApplicationRecord
  self.table_name = "audit_logs"

  validates :table_name, presence: true
  validates :action, presence: true, inclusion: { in: %w(INSERT UPDATE DELETE) }
end
