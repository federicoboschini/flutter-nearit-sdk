import 'package:nearit_sdk/objects/TrackingInfo.dart';

class InboxItem {
  final Map<dynamic, dynamic> _data;

  InboxItem._(this._data);

  TrackingInfo get trackingInfo => _data['trackingInfo'];
  ReactionBundle get reaction => _data['reaction'];
  int get timestamp => _data['timestamp'];
  bool get read => _data['read'];

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}

class ReactionBundle {
  final Map<dynamic, dynamic> _data;

  ReactionBundle._(this._data);

  String get notificationMessage => _data['notificationMessage'];
}