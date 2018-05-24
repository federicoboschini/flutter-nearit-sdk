import 'package:nearit_sdk/objects/Image.dart';
import 'dart:collection';

class Coupon {
  Map<dynamic, dynamic> _data;

  Coupon(LinkedHashMap map) {
    _data = map;
  }

  String get title => _data['title'];
  String get description => _data['description'];
  String get value => _data['value'];
  String get expiresAt => _data['expiresAt'];
  String get redeemableFrom => _data['redeemableFrom'];
  String get serial => _data['serial'];
  String get claimedAt => _data['claimedAt'];
  String get redeemedAt => _data['redeemedAt'];
  Image get image => Image(_data['image']);


  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}