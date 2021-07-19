class FilterModal{
  int? _filterId;
  String? _filter_name;
  List<Map<String,dynamic>>? _filters;

  FilterModal(this._filterId, this._filter_name, this._filters);

  List<Map<String, dynamic>>? get filters => _filters;

  String? get filter_name => _filter_name;

  int? get filterId => _filterId;

  Map toJson() {
    List<Map<String, dynamic>>? tags =
    this.filters != null ? this.filters!.map((i) => i).toList() : null;
    return {
      "filterId": filterId,
      "_filter_name": _filter_name,
      "_filters": tags
    };
  }


}