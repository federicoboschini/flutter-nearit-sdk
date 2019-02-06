import 'package:nearit_sdk/objects/Image.dart';
import 'dart:collection';

class Coupon {
  Map<dynamic, dynamic> _data;
  String _title;
  String _description;
  String _value;
  String _expiresAt;
  String _redeemableFrom;
  String _serial;
  String _claimedAt;
  String _redeemedAt;
  Image _image;

  Coupon(LinkedHashMap map) {
    _data = map;
    if (map.containsKey('title')) {
      _title = _data['title'];
    }
    if (map.containsKey('description')) {
      _description = _data['description'];
    }
    if (map.containsKey('value')) {
      _value = _data['value'];
    }
    if (map.containsKey('expiresAt')) {
      _expiresAt = _data['expiresAt'];
    }
    if (map.containsKey('redeemableFrom')) {
      _redeemableFrom = _data['redeemableFrom'];
    }
    if (map.containsKey('serial')) {
      _serial = _data['serial'];
    }
    if (map.containsKey('claimedAt')) {
      _claimedAt = _data['claimedAt'];
    }
    if (map.containsKey('redeemedAt')) {
      _redeemedAt = _data['redeemedAt'];
    }
    if (map.containsKey('image')) {
      _image = Image(_data['image']);
    }
  }

  String get title => _title;
  String get description => _description;
  String get value => _value;
  String get expiresAt => _expiresAt;
  String get redeemableFrom => _redeemableFrom;
  String get serial => _serial;
  String get claimedAt => _claimedAt;
  String get redeemedAt => _redeemedAt;
  Image get image => _image;


  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}