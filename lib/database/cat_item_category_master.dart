import 'package:floor/floor.dart';

@Entity(tableName: "cat_item_category_master")
class CatItemCategoryMaster{
  @PrimaryKey(autoGenerate: true)
  int? id;
  @ColumnInfo(name: "client_id")
  int? clientId;
  @ColumnInfo(name: "item_id")
  int? itemId;
  @ColumnInfo(name: "category_nm")
  String? categoryNm;
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

  CatItemCategoryMaster(
      this.id,
      this.clientId,
      this.itemId,
      this.categoryNm,
      this.remark,
      this.isActive,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.updatedBy);
}