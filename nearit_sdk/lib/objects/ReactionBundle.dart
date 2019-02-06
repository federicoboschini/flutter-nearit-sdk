import 'dart:collection';

class ReactionBundle {
  Map<dynamic, dynamic> _data;

  ReactionBundle(LinkedHashMap map) {
    _data = map;
  }

  String get notificationMessage => _data['notificationMessage'];
}