class TrackingInfo {
  final Map<dynamic, dynamic> _data;

  TrackingInfo._(this._data);

  String get DELIVERY_ID => _data['DELIVERY_ID'];
  String get recipeId => _data['recipeId'];

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}