import 'dart:collection';

class TrackingInfo {
  Map<dynamic, dynamic> _data;

  TrackingInfo(LinkedHashMap map) {
    _data = map;
  }

  String get recipeId => _data['recipeId'];

  Map<String, String> get metadata => _data['metadata'];
}