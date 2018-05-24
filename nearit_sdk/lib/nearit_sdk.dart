import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:nearit_sdk/objects/Coupon.dart';
import 'package:nearit_sdk/objects/InboxItem.dart';

class NearitSdk {
  static const MethodChannel _channel =
      const MethodChannel('com.nearit.flutter/nearit_sdk');

  static startRadar() {
    _channel.invokeMethod('startRadar');
  }

  static stopRadar() {
    _channel.invokeMethod('stopRadar');
  }

  static Future<String> getProfileId() async {
    return await _channel.invokeMethod('getProfileId');
  }

  static setProfileId(String profileId) {
    _channel.invokeMethod(
        'setProfileId', <String, dynamic>{'profileId': profileId});
  }

  static Future<String> resetProfileId() async {
    return await _channel.invokeMethod('resetProfileId');
  }

  static Future<List<Coupon>> getCoupons() async {
    final List<dynamic> data = await _channel.invokeMethod('getCoupons');
    final List<LinkedHashMap> castedData = data.cast<LinkedHashMap>().toList();

    final List<Coupon> couponList = new List();
    for (LinkedHashMap c in castedData) {
      Coupon co = Coupon(c);
      couponList.add(co);
    }
    return couponList;
  }

  static Future<List<InboxItem>> getInbox() async {
    final List<dynamic> data = await _channel.invokeMethod('getInbox');
    final List<InboxItem> inbox = data.cast<InboxItem>().toList();
    return inbox;
  }

  static setUserData(String key, String value) {
    _channel.invokeMethod('setUserData',
        <String, dynamic>{'userDataKey': key, 'userDataValue': value});
  }

  static setUserDataMulti() {
    // TODO: not implemented yet
  }

  static setUserBatchData(Map<String, Object> data) {
    _channel.invokeMethod('setUserData',
        <String, dynamic>{'userDataValue': data});
  }

  static triggerInAppEvent(String key) {
    _channel.invokeMethod(
        'triggerInAppEvent', <String, dynamic>{'inAppEvent': key});
  }

  static Future<bool> getOptOut() async {
    return await _channel.invokeMethod('getOptOut');
  }

  static optOut() async {
    await _channel.invokeMethod('optOut');
  }

  static sendEvent() {
    // TODO: not implemented yet
  }

  static sendTracking() {
    // TODO: not implemented yet
  }

  static enrollTestDevice(String deviceName) async {
    await _channel.invokeMethod(
        'enrollTestDevice', <String, dynamic>{'deviceName': deviceName});
  }

  static addProximityListener() {
    // TODO: not implemented yet
  }

  static removeProximityListener() {
    // TODO: not implemented yet
  }

  static disableDefaultRangingNotifications() {
    _channel.invokeMethod('disableDefaultRangingNotifications');
  }

  static setProximityNotificationIcon() {
    // TODO: not implemented yet
  }

  static setPushNotificationIcon() {
    // TODO: not implemented yet
  }


}
