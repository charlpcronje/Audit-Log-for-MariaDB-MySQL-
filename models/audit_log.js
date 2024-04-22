// Path: /models/audit_log.js
// Filename: audit_log.js
// Type: Model
// Structure Number: 7
// Iteration Number: 1
// Coding Level: B

const { Model, DataTypes } = require('sequelize');
const sequelize = require('../config/database'); // Adjust the import as per your project setup

class AuditLog extends Model {}

AuditLog.init({
  dtime: { type: DataTypes.DATE, defaultValue: DataTypes.NOW },
  table_name: { type: DataTypes.STRING },
  action: { type: DataTypes.ENUM('INSERT', 'UPDATE', 'DELETE') },
  json_log: { type: DataTypes.JSON },
  created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  sequelize,
  modelName: 'AuditLog',
  tableName: 'audit_logs',
  timestamps: false
});

module.exports = AuditLog;
