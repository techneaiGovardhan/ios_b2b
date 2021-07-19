/// id : 1181
/// employee_id : 2
/// employee_nm : "Vinaykumar Subhash Shinde"
/// remark : "CSV Upload"
/// is_active : "1"
/// created_at : null
/// updated_at : "2020-01-10 19:37:46"
/// created_by : null
/// updated_by : 222

class EmployeeDao {
  int? _id;
  int? _client_id;
  int? _employeeId;
  String? _employeeNm;
  String? _remark;
  String? _isActive;
  dynamic? _createdAt;
  String? _updatedAt;
  dynamic? _createdBy;
  int? _updatedBy;

  int? get id => _id;
  int? get employeeId => _employeeId;
  String? get employeeNm => _employeeNm;
  String? get remark => _remark;
  String? get isActive => _isActive;
  dynamic? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic? get createdBy => _createdBy;
  int? get updatedBy => _updatedBy;

  EmployeeDao({
      int? id, 
      int? employeeId, 
      String? employeeNm, 
      String? remark, 
      String? isActive, 
      dynamic? createdAt, 
      String? updatedAt, 
      dynamic? createdBy, 
      int? updatedBy}){
    _id = id;
    _employeeId = employeeId;
    _employeeNm = employeeNm;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _createdBy = createdBy;
    _updatedBy = updatedBy;

}

  EmployeeDao.fromJson(dynamic json) {
    _id = json["id"];
    _employeeId = json["employee_id"];
    _employeeNm = json["employee_nm"];
    _remark = json["remark"];
    _isActive = json["is_active"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
    _createdBy = json["created_by"];
    _updatedBy = json["updated_by"];
    _client_id = json["client_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["employee_id"] = _employeeId;
    map["employee_nm"] = _employeeNm;
    map["remark"] = _remark;
    map["is_active"] = _isActive;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    map["created_by"] = _createdBy;
    map["updated_by"] = _updatedBy;
    map["client_id"] = _client_id;
    return map;
  }

}