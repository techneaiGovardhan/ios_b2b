import 'package:floor/floor.dart';

@Entity(tableName: "glo_location_master")
class GloLocationMaster{
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: "location_nm")
  String? locationNm;
  @ColumnInfo(name: "site_id")
  int? siteId;
  @ColumnInfo(name: "client_id")
  int? clientId;
  @ColumnInfo(name: "remark")
  String? remark;
  @ColumnInfo(name: "is_active")
  String? isActive;
  @ColumnInfo(name: "created_at")
  String? createdAt;
  @ColumnInfo(name: "created_by")
  String? createdBy;
  @ColumnInfo(name: "updated_at")
  String? updatedAt;
  @ColumnInfo(name: "updated_by")
  String? updatedBy;

  GloLocationMaster(
      this.id,
      this.locationNm,
      this.siteId,
      this.clientId,
      this.remark,
      this.isActive,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy);
}