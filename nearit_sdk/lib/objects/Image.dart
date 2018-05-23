class Image {
  final Map<dynamic, dynamic> _data;

  Image._(this._data);

  String get fullSize => _data['fullSize'];
  String get squareSize => _data['squareSize'];
}