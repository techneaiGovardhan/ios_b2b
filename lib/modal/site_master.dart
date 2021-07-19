/// id : 1
/// site_nm : "Pune HO"
/// site_nm_as_per_erp : "Pune Ho"
/// client_id : 1
/// remark : null
/// is_active : "1"
/// created_at : null
/// created_by : null
/// updated_at : null
/// updated_by : null

class Site_master {
  int? _id;
  String? _siteNm;
  String? _siteNmAsPerErp;
  int? _clientId;
  dynamic? _remark;
  String? _isActive;
  dynamic? _createdAt;
  dynamic? _createdBy;
  dynamic? _updatedAt;
  dynamic? _updatedBy;

  int? get id => _id;
  String? get siteNm => _siteNm;
  String? get siteNmAsPerErp => _siteNmAsPerErp;
  int? get clientId => _clientId;
  dynamic? get remark => _remark;
  String? get isActive => _isActive;
  dynamic? get createdAt => _createdAt;
  dynamic? get createdBy => _createdBy;
  dynamic? get updatedAt => _updatedAt;
  dynamic? get updatedBy => _updatedBy;

  Site_master({
      int? id, 
      String? siteNm, 
      String? siteNmAsPerErp, 
      int? clientId, 
      dynamic? remark, 
      String? isActive, 
      dynamic? createdAt, 
      dynamic? createdBy, 
      dynamic? updatedAt, 
      dynamic? updatedBy}){
    _id = id;
    _siteNm = siteNm;
    _siteNmAsPerErp = siteNmAsPerErp;
    _clientId = clientId;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _createdBy = createdBy;
    _updatedAt = updatedAt;
    _updatedBy = updatedBy;
}

  Site_master.fromJson(dynamic json) {
    _id = json["id"];
    _siteNm = json["site_nm"];
    _siteNmAsPerErp = json["site_nm_as_per_erp"];
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
    map["site_nm"] = _siteNm;
    map["site_nm_as_per_erp"] = _siteNmAsPerErp;
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