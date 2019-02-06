import 'dart:collection';

import 'package:nearit_sdk/objects/ContentLink.dart';
import 'package:nearit_sdk/objects/Image.dart';
import 'package:nearit_sdk/objects/ReactionBundle.dart';

class Content extends ReactionBundle {

  String _title;
  String _content;
  String _link;
  String _updatedAt;
  Image _image;
  ContentLink _cta;

  Content(LinkedHashMap map) : super(map) {
    if (map.containsKey('title')) {
      _title = map['title'];
    }
    if (map.containsKey('content')) {
      _content = map['content'];
    }
    if (map.containsKey('link')) {
      _link = map['link'];
    }
    if (map.containsKey('updatedAt')) {
      _updatedAt = map['updatedAt'];
    }
    if (map.containsKey('image')) {
      _image = Image(map['image']);
    }
    if (map.containsKey('cta')) {
      _cta = ContentLink(map['cta']);
    }
  }

  String get title => _title;
  String get content => _content;
  String get link => _link;
  String get updatedAt => _updatedAt;
  Image get image => _image;
  ContentLink get cta => _cta;
}