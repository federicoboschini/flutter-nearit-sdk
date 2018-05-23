import 'package:nearit_sdk/objects/Image.dart';

class Coupon {
  final Map<dynamic, dynamic> _data;

  Coupon._(this._data);

  String get title => _data['title'];
  String get description => _data['description'];
  Image get image => _data['image'];
  String get value => _data['value'];
  String get expiresAt => _data['expiresAt'];
  String get redeemableFrom => _data['redeemableFrom'];
  String get serial => _data['serial'];
  String get claimedAt => _data['claimedAt'];
  String get redeemedAt => _data['redeemedAt'];

  @override
  String toString() {
    return '$runtimeType($_data)';
  }
}