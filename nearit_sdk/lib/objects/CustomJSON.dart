import 'dart:collection';

import 'package:nearit_sdk/objects/ReactionBundle.dart';

class CustomJSON extends ReactionBundle {
  Map<dynamic, dynamic> _content;

  CustomJSON(LinkedHashMap map) : super(map) {
    _content = map['content'];
  }

  Map<dynamic, dynamic> get content => _content;
}