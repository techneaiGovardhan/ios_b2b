  /// id : 1
/// client_id : 1
/// item_nm : "Silver Ring "
/// remark : null
/// is_active : "1"
/// created_at : null
/// created_by : null
/// updated_at : null
/// updated_by : null

class Cat_item_master {
  int? _id;
  int? _clientId;
  String? _itemNm;
  dynamic? _remark;
  String? _isActive;
  dynamic? _createdAt;
  dynamic? _createdBy;
  dynamic? _updatedAt;
  dynamic? _updatedBy;

  int? get id => _id;
  int? get clientId => _clientId;
  String? get itemNm => _itemNm;
  dynamic? get remark => _remark;
  String? get isActive => _isActive;
  dynamic? get createdAt => _createdAt;
  dynamic? get createdBy => _createdBy;
  dynamic? get updatedAt => _updatedAt;
  dynamic? get updatedBy => _updatedBy;

  Cat_item_master({
      int? id, 
      int? clientId, 
      String? itemNm, 
      dynamic? remark, 
      String? isActive, 
      dynamic? createdAt, 
      dynamic? createdBy, 
      dynamic? updatedAt, 
      dynamic? updatedBy}){
    _id = id;
    _clientId = clientId;
    _itemNm = itemNm;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
}

  Cat_item_master.fromJson(dynamic json) {
    _id = json["id"];
    _clientId = json["client_id"];
    _itemNm = json["item_nm"];
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
    map["item_nm"] = _itemNm;
    map["remark"] = _remark;
    map["is_active"] = _isActive;
    map["created_at"] = _createdAt;
    map["created_by"] = _createdBy;
    map["updated_at"] = _updatedAt;
    map["updated_by"] = _updatedBy;
    return map;
  }

}