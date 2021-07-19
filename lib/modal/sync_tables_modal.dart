import 'dart:collection';

/// status : 1
/// message : "Sync Table Send"
/// data : {"structure":[{"table":"employee","query":"CREATE TABLE IF NOT EXISTS employee(id INTEGER PRIMARY KEY,employee_id TEXT null,employee_nm TEXT);"},{"table":"glo_site_master","query":"CREATE TABLE IF NOT EXISTS glo_site_master( id INTEGER PRIMARY KEY,site_nm TEXT NULL,site_nm_as_per_erp TEXT NULL,client_id INTEGER NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_location_master","query":"CREATE TABLE IF NOT EXISTS glo_location_master( id INTEGER PRIMARY KEY,location_nm TEXT NULL,site_id INTEGER NULL,client_id INTEGER NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_item_master","query":"CREATE TABLE IF NOT EXISTS cat_item_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_item_category_master","query":"CREATE TABLE IF NOT EXISTS cat_item_category_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_id INTEGER NULL,category_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_product_detail","query":"CREATE TABLE IF NOT EXISTS cat_product_detail( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_id INTEGER NULL,category_id INTEGER NULL,barcode_no TEXT NULL,purity FLOAT NULL,size FLOAT NULL,gross_wt FLOAT NULL,net_wt FLOAT NULL,wastage TEXT NULL,pieces INTEGER NULL,is_studed TEXT NULL,current_rate FLOAT NULL,product_price FLOAT NULL,current_status TEXT NULL,current_location TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_wastage_master","query":"CREATE TABLE IF NOT EXISTS cat_wastage_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,wastage_nm TEXT NULL,site_nm_as_per_erp TEXT NULL,site_id INTEGER NULL,wastage_on TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_setting_master","query":"CREATE TABLE IF NOT EXISTS glo_setting_master( id INTEGER PRIMARY KEY,module_nm TEXT NULL,sub_module_nm TEXT NULL,setting_nm TEXT NULL,setting_data_type TEXT NULL,setting_value TEXT NULL,default_value TEXT NULL,is_editable TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_setting_detail","query":"CREATE TABLE IF NOT EXISTS glo_setting_detail( id INTEGER PRIMARY KEY,client_id INTEGER NULL,setting_id INTEGER NULL,setting_value TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_customer_details","query":"CREATE TABLE IF NOT EXISTS pos_customer_details( id INTEGER PRIMARY KEY,client_id INTEGER NULL,pos_id INTEGER NULL,mac_address TEXT NULL,customer_mobile_no TEXT NULL,employee_id INTEGER NULL,in_dt DATETIME NULL,out_dt DATETIME NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_customer_activity","query":"CREATE TABLE IF NOT EXISTS pos_customer_activity( id INTEGER PRIMARY KEY,client_id INTEGER NULL,pos_id INTEGER NULL,mac_address TEXT NULL,customer_id INTEGER NULL,activity_comman_id INTEGER NULL,activity TEXT NULL,activity_criteria TEXT NULL,value1 TEXT NULL,value12 TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_order_details","query":"CREATE TABLE IF NOT EXISTS pos_order_details( id INTEGER PRIMARY KEY,pos_id INTEGER NULL,mac_address TEXT NULL,customer_id INTEGER NULL,customer_mobile_no TEXT NULL,expected_delivery_dt DATE NULL,sales_person_id INTEGER NULL,sales_person_nm TEXT NULL,product_code TEXT NULL,occasions_details TEXT NULL,custome_visit_date DATE NULL,custome_visit_time TIME NULL,from_site INTEGER NULL,from_location INTEGER NULL,to_site INTEGER NULL,order_status TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_employee_master","query":"CREATE TABLE IF NOT EXISTS glo_employee_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,employee_id TEXT NULL,employee_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_rate_master","query":"CREATE TABLE IF NOT EXISTS glo_rate_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,purity TEXT NULL,rate FLOAT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"}],"syncTable":[{"id":2,"api_name":"employee","type":"pull","api":"/api/v1/sync/employee","api_to_get_last_record":"/api/v1/lastRecord/employee","dataformat":"{macAddress:<mac>,secretKey:<auth>,last_updated_at:<var1>,count:<var2>\r}","var1":"select * from employee where id > <var>","var2":"select count(*) from glo_empoyee_master where updated_at=<var>;","var3":null,"var4":null,"var5":null,"label_on_screen":"Employee Sync","table_to_affect":"employee","is_active":"1","execution_order":1,"last_updated_at":"2021-06-30 10:31:22","run_in_sync":"Y"},{"id":1,"api_name":"Product","type":"pull","api":"/api/v1/sync/product","api_to_get_last_record":"/api/v1/lastRecord/product","dataformat":"{macAddress:<mac>,secretKey:<auth>,last_updated_at:<var1>,count:<var2>}","var1":"select * from cat_product_detail where id > <var>","var2":"select count(*) from glo_product_detail where updated_at=<var>;","var3":null,"var4":null,"var5":null,"label_on_screen":"Product Sync","table_to_affect":"product","is_active":null,"execution_order":2,"last_updated_at":"2021-06-30 10:31:19","run_in_sync":"Y"}]}

class SyncTablesModal {
  int? _status;
  String? _message;
  Data? _data;

  int? get status => _status;
  String? get message => _message;
  Data? get data => _data;

  SyncTablesModal({
      int? status, 
      String? message, 
      Data? data}){
    _status = status;
    _message = message;
    _data = data;
}

  SyncTablesModal.fromJson(HashMap<String,dynamic> json) {
    _status = json["status"];
    _message = json["message"];
    //_data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

/// structure : [{"table":"employee","query":"CREATE TABLE IF NOT EXISTS employee(id INTEGER PRIMARY KEY,employee_id TEXT null,employee_nm TEXT);"},{"table":"glo_site_master","query":"CREATE TABLE IF NOT EXISTS glo_site_master( id INTEGER PRIMARY KEY,site_nm TEXT NULL,site_nm_as_per_erp TEXT NULL,client_id INTEGER NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_location_master","query":"CREATE TABLE IF NOT EXISTS glo_location_master( id INTEGER PRIMARY KEY,location_nm TEXT NULL,site_id INTEGER NULL,client_id INTEGER NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_item_master","query":"CREATE TABLE IF NOT EXISTS cat_item_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_item_category_master","query":"CREATE TABLE IF NOT EXISTS cat_item_category_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_id INTEGER NULL,category_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_product_detail","query":"CREATE TABLE IF NOT EXISTS cat_product_detail( id INTEGER PRIMARY KEY,client_id INTEGER NULL,item_id INTEGER NULL,category_id INTEGER NULL,barcode_no TEXT NULL,purity FLOAT NULL,size FLOAT NULL,gross_wt FLOAT NULL,net_wt FLOAT NULL,wastage TEXT NULL,pieces INTEGER NULL,is_studed TEXT NULL,current_rate FLOAT NULL,product_price FLOAT NULL,current_status TEXT NULL,current_location TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"cat_wastage_master","query":"CREATE TABLE IF NOT EXISTS cat_wastage_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,wastage_nm TEXT NULL,site_nm_as_per_erp TEXT NULL,site_id INTEGER NULL,wastage_on TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_setting_master","query":"CREATE TABLE IF NOT EXISTS glo_setting_master( id INTEGER PRIMARY KEY,module_nm TEXT NULL,sub_module_nm TEXT NULL,setting_nm TEXT NULL,setting_data_type TEXT NULL,setting_value TEXT NULL,default_value TEXT NULL,is_editable TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_setting_detail","query":"CREATE TABLE IF NOT EXISTS glo_setting_detail( id INTEGER PRIMARY KEY,client_id INTEGER NULL,setting_id INTEGER NULL,setting_value TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_customer_details","query":"CREATE TABLE IF NOT EXISTS pos_customer_details( id INTEGER PRIMARY KEY,client_id INTEGER NULL,pos_id INTEGER NULL,mac_address TEXT NULL,customer_mobile_no TEXT NULL,employee_id INTEGER NULL,in_dt DATETIME NULL,out_dt DATETIME NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_customer_activity","query":"CREATE TABLE IF NOT EXISTS pos_customer_activity( id INTEGER PRIMARY KEY,client_id INTEGER NULL,pos_id INTEGER NULL,mac_address TEXT NULL,customer_id INTEGER NULL,activity_comman_id INTEGER NULL,activity TEXT NULL,activity_criteria TEXT NULL,value1 TEXT NULL,value12 TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"pos_order_details","query":"CREATE TABLE IF NOT EXISTS pos_order_details( id INTEGER PRIMARY KEY,pos_id INTEGER NULL,mac_address TEXT NULL,customer_id INTEGER NULL,customer_mobile_no TEXT NULL,expected_delivery_dt DATE NULL,sales_person_id INTEGER NULL,sales_person_nm TEXT NULL,product_code TEXT NULL,occasions_details TEXT NULL,custome_visit_date DATE NULL,custome_visit_time TIME NULL,from_site INTEGER NULL,from_location INTEGER NULL,to_site INTEGER NULL,order_status TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_employee_master","query":"CREATE TABLE IF NOT EXISTS glo_employee_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,employee_id TEXT NULL,employee_nm TEXT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"},{"table":"glo_rate_master","query":"CREATE TABLE IF NOT EXISTS glo_rate_master( id INTEGER PRIMARY KEY,client_id INTEGER NULL,purity TEXT NULL,rate FLOAT NULL,remark TEXT NULL,is_active TEXT NULL,created_at DATETIME NULL,created_by INTEGER NULL,updated_at DATETIME NULL,updated_by INTEGER NULL);"}]
/// syncTable : [{"id":2,"api_name":"employee","type":"pull","api":"/api/v1/sync/employee","api_to_get_last_record":"/api/v1/lastRecord/employee","dataformat":"{macAddress:<mac>,secretKey:<auth>,last_updated_at:<var1>,count:<var2>\r}","var1":"select * from employee where id > <var>","var2":"select count(*) from glo_empoyee_master where updated_at=<var>;","var3":null,"var4":null,"var5":null,"label_on_screen":"Employee Sync","table_to_affect":"employee","is_active":"1","execution_order":1,"last_updated_at":"2021-06-30 10:31:22","run_in_sync":"Y"},{"id":1,"api_name":"Product","type":"pull","api":"/api/v1/sync/product","api_to_get_last_record":"/api/v1/lastRecord/product","dataformat":"{macAddress:<mac>,secretKey:<auth>,last_updated_at:<var1>,count:<var2>}","var1":"select * from cat_product_detail where id > <var>","var2":"select count(*) from glo_product_detail where updated_at=<var>;","var3":null,"var4":null,"var5":null,"label_on_screen":"Product Sync","table_to_affect":"product","is_active":null,"execution_order":2,"last_updated_at":"2021-06-30 10:31:19","run_in_sync":"Y"}]

class Data {
  List<Structure>? _structure;
  List<SyncTable>? _syncTable;

  List<Structure>? get structure => _structure;
  List<SyncTable>? get syncTable => _syncTable;

  Data({
      List<Structure>? structure, 
      List<SyncTable>? syncTable}){
    _structure = structure;
    _syncTable = syncTable;
}

  Data.fromJson(HashMap<String,dynamic> json) {
    if (json["structure"] != null) {
      _structure = [];
      json["structure"].forEach((v) {
        _structure?.add(Structure.fromJson(v));
      });
    }
    if (json["syncTable"] != null) {
      _syncTable = [];
      json["syncTable"].forEach((v) {
        _syncTable?.add(SyncTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_structure != null) {
      map["structure"] = _structure?.map((v) => v.toJson()).toList();
    }
    if (_syncTable != null) {
      map["syncTable"] = _syncTable?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 2
/// api_name : "employee"
/// type : "pull"
/// api : "/api/v1/sync/employee"
/// api_to_get_last_record : "/api/v1/lastRecord/employee"
/// dataformat : "{macAddress:<mac>,secretKey:<auth>,last_updated_at:<var1>,count:<var2>\r}"
/// var1 : "select * from employee where id > <var>"
/// var2 : "select count(*) from glo_empoyee_master where updated_at=<var>;"
/// var3 : null
/// var4 : null
/// var5 : null
/// label_on_screen : "Employee Sync"
/// table_to_affect : "employee"
/// is_active : "1"
/// execution_order : 1
/// last_updated_at : "2021-06-30 10:31:22"
/// run_in_sync : "Y"

class SyncTable {
  int? _id;
  String? _apiName;
  String? _type;
  String? _api;
  String? _apiToGetLastRecord;
  String? _dataformat;
  String? _var1;
  String? _var2;
  dynamic? _var3;
  dynamic? _var4;
  dynamic? _var5;
  String? _labelOnScreen;
  String? _tableToAffect;
  String? _isActive;
  int? _executionOrder;
  String? _lastUpdatedAt;
  String? _runInSync;

  int? get id => _id;
  String? get apiName => _apiName;
  String? get type => _type;
  String? get api => _api;
  String? get apiToGetLastRecord => _apiToGetLastRecord;
  String? get dataformat => _dataformat;
  String? get var1 => _var1;
  String? get var2 => _var2;
  dynamic? get var3 => _var3;
  dynamic? get var4 => _var4;
  dynamic? get var5 => _var5;
  String? get labelOnScreen => _labelOnScreen;
  String? get tableToAffect => _tableToAffect;
  String? get isActive => _isActive;
  int? get executionOrder => _executionOrder;
  String? get lastUpdatedAt => _lastUpdatedAt;
  String? get runInSync => _runInSync;

  SyncTable({
      int? id, 
      String? apiName, 
      String? type, 
      String? api, 
      String? apiToGetLastRecord, 
      String? dataformat, 
      String? var1, 
      String? var2, 
      dynamic? var3, 
      dynamic? var4, 
      dynamic? var5, 
      String? labelOnScreen, 
      String? tableToAffect, 
      String? isActive, 
      int? executionOrder, 
      String? lastUpdatedAt, 
      String? runInSync}){
    _id = id;
    _apiName = apiName;
    _type = type;
    _api = api;
    _apiToGetLastRecord = apiToGetLastRecord;
    _dataformat = dataformat;
    _var1 = var1;
    _var2 = var2;
    _var3 = var3;
    _var4 = var4;
    _var5 = var5;
    _labelOnScreen = labelOnScreen;
    _tableToAffect = tableToAffect;
    _isActive = isActive;
    _executionOrder = executionOrder;
    _lastUpdatedAt = lastUpdatedAt;
    _runInSync = runInSync;
}

  SyncTable.fromJson(dynamic json) {
    _id = json["id"];
    _apiName = json["api_name"];
    _type = json["type"];
    _api = json["api"];
    _apiToGetLastRecord = json["api_to_get_last_record"];
    _dataformat = json["dataformat"];
    _var1 = json["var1"];
    _var2 = json["var2"];
    _var3 = json["var3"];
    _var4 = json["var4"];
    _var5 = json["var5"];
    _labelOnScreen = json["label_on_screen"];
    _tableToAffect = json["table_to_affect"];
    _isActive = json["is_active"];
    _executionOrder = json["execution_order"];
    _lastUpdatedAt = json["last_updated_at"];
    _runInSync = json["run_in_sync"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["api_name"] = _apiName;
    map["type"] = _type;
    map["api"] = _api;
    map["api_to_get_last_record"] = _apiToGetLastRecord;
    map["dataformat"] = _dataformat;
    map["var1"] = _var1;
    map["var2"] = _var2;
    map["var3"] = _var3;
    map["var4"] = _var4;
    map["var5"] = _var5;
    map["label_on_screen"] = _labelOnScreen;
    map["table_to_affect"] = _tableToAffect;
    map["is_active"] = _isActive;
    map["execution_order"] = _executionOrder;
    map["last_updated_at"] = _lastUpdatedAt;
    map["run_in_sync"] = _runInSync;
    return map;
  }

}

/// table : "employee"
/// query : "CREATE TABLE IF NOT EXISTS employee(id INTEGER PRIMARY KEY,employee_id TEXT null,employee_nm TEXT);"

class Structure {
  String? _table;
  String? _query;

  String? get table => _table;
  String? get query => _query;

  Structure({
      String? table, 
      String? query}){
    _table = table;
    _query = query;
}

  Structure.fromJson(dynamic json) {
    _table = json["table"];
    _query = json["query"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["table"] = _table;
    map["query"] = _query;
    return map;
  }

}