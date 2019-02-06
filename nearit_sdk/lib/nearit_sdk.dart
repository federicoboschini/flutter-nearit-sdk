import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:nearit_sdk/objects/Coupon.dart';
import 'package:nearit_sdk/objects/HistoryItem.dart';
import 'package:nearit_sdk/objects/TrackingInfo.dart';

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
    for (LinkedHashMap map in castedData) {
      Coupon coupon = Coupon(map);
      couponList.add(coupon);
    }
    return couponList;
  }

  static Future<List<HistoryItem>> getNotificationHistory() async {
    final List<dynamic> data =
        await _channel.invokeMethod('getNotificationHistory');
    final List<LinkedHashMap> castedData = data.cast<LinkedHashMap>().toList();
    final List<HistoryItem> inbox = new List();
    for (LinkedHashMap map in castedData) {
      HistoryItem item = HistoryItem(map);
      inbox.add(item);
    }
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
    _channel
        .invokeMethod('setUserData', <String, dynamic>{'userDataValue': data});
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

  static sendFeedback() async {
    // TODO: not implemented yet
  }

  static sendTracking(TrackingInfo trackingInfo, String trackingEvent) async {
    var tracking = Map<String, Object>();
    tracking['recipeId'] = trackingInfo.recipeId;
    tracking['metadata'] = trackingInfo.metadata;
    await _channel.invokeMethod('sendTracking', <String, dynamic>{
      'trackingInfo': tracking,
      'trackingEvent': trackingEvent
    });
  }

  static enrollTestDevice(String deviceName) async {
    await _channel.invokeMethod(
        'enrollTestDevice', <String, dynamic>{'deviceName': deviceName});
  }

  static disableDefaultRangingNotifications() {
    _channel.invokeMethod('disableDefaultRangingNotifications');
  }
}
