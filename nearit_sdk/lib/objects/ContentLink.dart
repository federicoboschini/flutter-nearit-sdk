import 'dart:collection';

class ContentLink {

  String _label;
  String _url;

  ContentLink(LinkedHashMap map) {
    if (map.containsKey('label')) {
      _label = map['label'];
    }
    if (map.containsKey('url')) {
      _url = map['url'];
    }
  }

  String get label => _label;
  String get url => _url;
}