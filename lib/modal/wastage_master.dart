class WastageMaster {
  int ? id;
  int ? client_id;
  String?  wastage_nm;
  String? site_nm_as_per_erp;
  String? site_id;
  String?  wastage_on;
  String? remark;
  String? is_active;
  String? created_at;
  String? created_by;
  String? updated_at;
  String? updated_by;

  WastageMaster(
      this.id,
      this.client_id,
      this.wastage_nm,
      this.site_nm_as_per_erp,
      this.site_id,
      this.wastage_on,
      this.remark,
      this.is_active,
      this.created_at,
      this.created_by,
      this.updated_at,
      this.updated_by);

  WastageMaster.fromJson(dynamic json){
    id = json['id'];
    client_id=json['client_id'];
    wastage_nm=json['wastage_nm'];
    site_nm_as_per_erp=json['site_nm_as_per_erp'];
    site_id = json['site_id'];
    wastage_on = json['wastage_on'];
    remark   = json['remark'];
    is_active  = json['is_active'];
    created_at = json['created_at'];
    created_by  = json['created_by'];
    updated_at = json['updated_at'];
    updated_by  = json['updated_by'];
  }

  Map<String,dynamic> toJson(){
    Map<String,dynamic> map=Map();
    map['id'] =   id;
    map['client_id'] = client_id;
    map['wastage_nm'] = wastage_nm;
    map['site_nm_as_per_erp'] = site_nm_as_per_erp;
    map['site'] =  site_id;
    map['wastage'] = wastage_on;
    map['remark'] = remark;
    map['is_active'] =  is_active;
    map['created_at'] = created_at;
    map['created_by'] = created_by;
    map['updated_at'] = updated_at;
    map['updated_by'] = updated_by;
    return map;
  }
}