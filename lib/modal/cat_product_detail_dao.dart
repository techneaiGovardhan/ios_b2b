/// id : 1
/// product_price : 99
/// barcode_no : "UTN1211697"
/// purity : 95
/// size : 2
/// net_wt : 200
/// wastage : "94"
/// pieces : 1
/// current_location : "Pune HO"
/// client_id : 1
/// category_id : 1
/// item_id : 1
/// gross_wt : 200
/// is_studed : "N"
/// current_rate : 90
/// current_status : null
/// remark : null
/// is_active : "1"
/// created_at : null
/// updated_at : null

class Cat_product_detail_dao {
  int? _id;
  double? _productPrice;
  //int? _productPrice;
  String? _barcodeNo;
  //int? _purity;
  //int? _size;
  //int? _netWt;
  double? _purity;
  double? _size;
  double? _netWt;
  String? _wastage;
  int? _pieces;
  String? _currentLocation;
  int? _clientId;
  int? _categoryId;
  int? _itemId;
  double? _grossWt;
  String? _isStuded;
  double? _currentRate;
  dynamic _currentStatus;
  dynamic _remark;
  String? _isActive;
  dynamic _createdAt;
  dynamic _updatedAt;

  int? get id => _id;
  double? get productPrice => _productPrice;
  //int? get productPrice => _productPrice;
  String? get barcodeNo => _barcodeNo;
  double? get purity => _purity;
  //int? get purity => _purity;
  double? get size => _size;
  //int? get size => _size;
  //int? get netWt => _netWt;
  double? get netWt => _netWt;
  String? get wastage => _wastage;
  int? get pieces => _pieces;
  String? get currentLocation => _currentLocation;
  int? get clientId => _clientId;
  int? get categoryId => _categoryId;
  int? get itemId => _itemId;
  //int? get grossWt => _grossWt;
  double? get grossWt => _grossWt;
  String? get isStuded => _isStuded;
  double? get currentRate => _currentRate;
  dynamic get currentStatus => _currentStatus;
  dynamic get remark => _remark;
  String? get isActive => _isActive;
  dynamic get createdAt => _createdAt;
  dynamic get updatedAt => _updatedAt;

  Cat_product_detail_dao({
      int? id, 
      double? productPrice,
    // int? productPrice,
    String? barcodeNo,
    double? purity,
    //int? purity,
    //int? size,
     double? size,
      double? netWt,
     int? newWt,
      String? wastage,
      int? pieces, 
      String? currentLocation, 
      int? clientId, 
      int? categoryId, 
      int? itemId, 
      double? grossWt,
      String? isStuded, 
      double? currentRate,
      dynamic currentStatus,
      dynamic remark,
      String? isActive,
      dynamic createdAt,
      dynamic updatedAt}){
    _id = id;
    _productPrice = productPrice;
    _barcodeNo = barcodeNo;
    _purity = purity;
    _size = size;
    _netWt = netWt;
    _wastage = wastage;
    _pieces = pieces;
    _currentLocation = currentLocation;
    _clientId = clientId;
    _categoryId = categoryId;
    _itemId = itemId;
    _grossWt = grossWt;
    _isStuded = isStuded;
    _currentRate = currentRate;
    _currentStatus = currentStatus;
    _remark = remark;
    _isActive = isActive;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Cat_product_detail_dao.fromJson(dynamic json) {
    _id = json["id"];
    _productPrice = double.parse(json["product_price"].toString());
    _barcodeNo = json["barcode_no"];
    _purity = double.parse(json["purity"].toString());
    _size = double.parse(json["size"].toString());
    _netWt = double.parse(json["net_wt"].toString());
    _wastage = json["wastage"];
    _pieces = json["pieces"];
    _currentLocation = json["current_location"];
    _clientId = json["client_id"];
    _categoryId = json["category_id"];
    _itemId = json["item_id"];
    _grossWt =double.parse(json["gross_wt"].toString());
    _isStuded = json["is_studed"];
    _currentRate =double.parse(json["current_rate"].toString());
    _currentStatus = json["current_status"];
    _remark = json["remark"];
    _isActive = json["is_active"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["product_price"] = _productPrice;
    map["barcode_no"] = _barcodeNo;
    map["purity"] = _purity;
    map["size"] = _size;
    map["net_wt"] = _netWt;
    map["wastage"] = _wastage;
    map["pieces"] = _pieces;
    map["current_location"] = _currentLocation;
    map["client_id"] = _clientId;
    map["category_id"] = _categoryId;
    map["item_id"] = _itemId;
    map["gross_wt"] = _grossWt;
    map["is_studed"] = _isStuded;
    map["current_rate"] = _currentRate;
    map["current_status"] = _currentStatus;
    map["remark"] = _remark;
    map["is_active"] = _isActive;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }

}