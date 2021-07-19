/// id : 1
/// location_nm : "Ring Counter"
/// site_id : 1
/// client_id : 1
/// remark : null
/// is_active : "1"
/// created_at : null
/// created_by : null
/// updated_at : null
/// updated_by : null

class Location_master {
  int? _id;
  String? _locationNm;
  int? _siteId;
  int? _clientId;
  dynamic? _remark;
  String? _isActive;
  dynamic? _createdAt;
  dynamic? _createdBy;
  dynamic? _updatedAt;
  dynamic? _updatedBy;

  int? get id => _id;
  String? get locationNm => _locationNm;
  int? get siteId => _siteId;
  int? get clientId => _clientId;
  dynamic? get remark => _remark;
  String? get isActive => _isActive;
  dynamic? get createdAt => _createdAt;
  dynamic? get createdBy => _createdBy;
  dynamic? get updatedAt => _updatedAt;
  dynamic? get updatedBy => _updatedBy;

  Location_master({
      int? id, 
      String? locationNm, 
      int? siteId, 
      int? clientId, 
      dynamic? remark, 
      String? isActive, 
      dynamic? createdAt, 
      dynamic? createdBy, 
      dynamic? updatedAt, 
      dynamic? updatedBy}){
    _id = id;
    _locationNm = locationNm;
    _siteId = siteId;
    _clientId = clientId;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
}

  Location_master.fromJson(dynamic json) {
    _id = json["id"];
    _locationNm = json["location_nm"];
    _siteId = json["site_id"];
    _clientId = json["client_id"];
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
    map["location_nm"] = _locationNm;
    map["site_id"] = _siteId;
    map["client_id"] = _clientId;
    map["remark"] = _remark;
    map["is_active"] = _isActive;
    map["created_at"] = _createdAt;
    map["created_by"] = _createdBy;
    map["updated_at"] = _updatedAt;
    map["updated_by"] = _updatedBy;
    return map;
  }

}