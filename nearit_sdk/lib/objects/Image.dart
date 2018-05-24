import 'dart:collection';

class Image {
  Map<dynamic, dynamic> _data;

  Image(LinkedHashMap map) {
    _data = map;
  }

  String get fullSize => _data['fullSize'];
  String get squareSize => _data['squareSize'];
}