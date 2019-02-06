import 'dart:collection';

import 'package:nearit_sdk/objects/Content.dart';
import 'package:nearit_sdk/objects/CustomJSON.dart';
import 'package:nearit_sdk/objects/NearItFeedback.dart';
import 'package:nearit_sdk/objects/ReactionBundle.dart';
import 'package:nearit_sdk/objects/SimpleNotification.dart';
import 'package:nearit_sdk/objects/TrackingInfo.dart';

class HistoryItem {
  Map<dynamic, dynamic> _data;
  TrackingInfo _trackingInfo;
  String _type;
  ReactionBundle _reactionBundle;

  HistoryItem(LinkedHashMap map) {
    _data = map;
    _trackingInfo = new TrackingInfo(_data['trackingInfo']);
    _type = _data['type'];

    switch (_type) {
      case 'SimpleNotification':
        _reactionBundle = SimpleNotification(_data['content']);
        break;
      case 'CustomJSON':
        _reactionBundle = CustomJSON(_data['content']);
        break;
      case 'Content':
        _reactionBundle = Content(_data['content']);
        break;
      case 'Feedback':
        _reactionBundle = NearItFeedback(_data['content']);
        break;
    }
  }

  TrackingInfo get trackingInfo => _trackingInfo;
  int get timestamp => _data['timestamp'];
  bool get read => _data['read'];
  String get type => _type;
  ReactionBundle get reaction => _reactionBundle;

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}
