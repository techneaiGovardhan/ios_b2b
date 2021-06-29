import 'package:floor/floor.dart';

@Entity(tableName: "glo_employee_master")
class GloEmployeeMaster{
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name:"client_id")
  String? clientId;
  @ColumnInfo(name:"employee_id")
  String? employeeId;
  @ColumnInfo(name: "employee_name")
  String? employeeName;
  @ColumnInfo(name:"remark")
  String? remark;
  @ColumnInfo(name:"is_active")
  String? isActive;
  @ColumnInfo(name: "created_at")
  String? createdAt;
  @ColumnInfo(name:"created_by")
  String? createdBy;
  @ColumnInfo(name:"updated_at")
  String? updatedAt;
  @ColumnInfo(name:"updated_by")
  String? updatedBy;

  GloEmployeeMaster(
      this.id,
      this.clientId,
      this.employeeId,
      this.employeeName,
      this.remark,
      this.isActive,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy);
}