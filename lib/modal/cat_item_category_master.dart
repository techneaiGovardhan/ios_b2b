/// id : 2
/// client_id : 1
/// item_id : 1
/// category_nm : "Silver"
/// remark : null
/// is_active : "1"
/// created_at : null
/// created_by : 118
/// updated_at : null
/// updated_by : 118

class Cat_item_category_master {
  int? _id;
  int? _clientId;
  int? _itemId;
  String? _categoryNm;
  dynamic? _remark;
  String? _isActive;
  dynamic? _createdAt;
  int? _createdBy;
  dynamic? _updatedAt;
  int? _updatedBy;

  int? get id => _id;
  int? get clientId => _clientId;
  int? get itemId => _itemId;
  String? get categoryNm => _categoryNm;
  dynamic? get remark => _remark;
  String? get isActive => _isActive;
  dynamic? get createdAt => _createdAt;
  int? get createdBy => _createdBy;
  dynamic? get updatedAt => _updatedAt;
  int? get updatedBy => _updatedBy;

  Cat_item_category_master({
      int? id, 
      int? clientId, 
      int? itemId, 
      String? categoryNm, 
      dynamic? remark, 
      String? isActive, 
      dynamic? createdAt, 
      int? createdBy, 
      dynamic? updatedAt, 
      int? updatedBy}){
    _id = id;
    _clientId = clientId;
    _itemId = itemId;
    _categoryNm = categoryNm;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
}

  Cat_item_category_master.fromJson(dynamic json) {
    _id = json["id"];
    _clientId = json["client_id"];
    _itemId = json["item_id"];
    _categoryNm = json["category_nm"];
    _remark = json["remark"];
    _isActive = json["is_active"];
    _createdAt = json["created_at"];
    _createdBy = json["created_by"];
    _updatedAt = json["updated_at"];
    _updatedBy = json["updated_by"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["client_id"] = _clientId;
    map["item_id"] = _itemId;
    map["category_nm"] = _categoryNm;
    map["remark"] = _remark;
    map["is_active"] = _isActive;
    map["created_at"] = _createdAt;
    map["created_by"] = _createdBy;
    map["updated_at"] = _updatedAt;
    map["updated_by"] = _updatedBy;
    return map;
  }

}