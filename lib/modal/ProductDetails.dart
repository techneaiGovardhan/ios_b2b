class ProductDetails{
 // int? _id;
//   int? _productPrice;
//   String? _barcodeNo;
// //  double? _purity;
//   //double? _size;
//   //double? _netWt;
//   int? _purity;
//   int? _size;
//   int? _netWt;
//   String? _wastage;
//   int? _pieces;
//   String? _currentLocation;
//   int? _clientId;
//   int? _categoryId;
//   int? _itemId;
//   int? _grossWt;
//   String? _isStuded;
//   int? _currentRate;
//   dynamic _currentStatus;
//   dynamic _remark;
//   String? _isActive;
//   dynamic _createdAt;
//   dynamic _updatedAt;
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
  String product_name;


  ProductDetails(
      this._id,
      this.product_name,
      this._productPrice,
      this._barcodeNo,
      this._purity,
      this._size,
      this._netWt,
      this._wastage,
      this._pieces,
      this._currentLocation,
      this._clientId,
      this._categoryId,
      this._itemId,
      this._grossWt,
      this._isStuded,
      this._currentRate,
      this._currentStatus,
      this._remark,
      this._isActive,
      this._createdAt,
      this._updatedAt);

  // dynamic get updatedAt => _updatedAt;
  //
  // dynamic get createdAt => _createdAt;
  //
  // String? get isActive => _isActive;
  //
  // dynamic get remark => _remark;
  //
  // dynamic get currentStatus => _currentStatus;
  //
  // int? get currentRate => _currentRate;
  //
  // String? get isStuded => _isStuded;
  //
  // int? get grossWt => _grossWt;
  //
  // int? get itemId => _itemId;
  //
  // int? get categoryId => _categoryId;
  //
  // int? get clientId => _clientId;
  //
  // String? get currentLocation => _currentLocation;
  //
  // int? get pieces => _pieces;
  //
  // String? get wastage => _wastage;
  //
  // int? get netWt => _netWt;
  //
  // // int? get size = _size;
  // int? get size => _size;
  //
  // int? get purity => _purity;
  //
  // String? get barcodeNo => _barcodeNo;
  //
  // int? get productPrice => _productPrice;
  //
  // int? get id => _id;
}