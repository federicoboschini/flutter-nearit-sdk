import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearit_sdk/nearit_sdk.dart';
import 'package:nearit_sdk/objects/Content.dart';
import 'package:nearit_sdk/objects/Coupon.dart';
import 'package:nearit_sdk/objects/CustomJSON.dart';
import 'package:nearit_sdk/objects/NearItFeedback.dart';
import 'package:nearit_sdk/objects/HistoryItem.dart';
import 'package:nearit_sdk/objects/SimpleNotification.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _profileId = 'Unknown';

  final myController = new TextEditingController();
  final keyController = new TextEditingController();
  final valueController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    getProfileId();
  }

  getProfileId() async {
    String profileId;
    try {
      profileId = await NearitSdk.getProfileId();
    } on PlatformException {
      profileId = 'Failed to get profileId.';
    }
    updateProfileId(profileId);
  }

  resetProfileId() async {
    String profileId;
    try {
      profileId = await NearitSdk.resetProfileId();
    } on PlatformException {
      profileId = 'Failed to get profileId.';
    }
    updateProfileId(profileId);
  }

  setProfileId() {
    if (myController.text != null) {
      NearitSdk.setProfileId(myController.text);
      getProfileId();
    }
  }

  updateProfileId(String profileId) {
    if (!mounted) return;

    setState(() {
      _profileId = profileId;
    });
  }

  setUserData() {
    NearitSdk.setUserData("chiave", valueController.text);
  }

  getNotificationHistory() async {
    List<HistoryItem> inbox;
    try {
      inbox = await NearitSdk.getNotificationHistory();
    } on PlatformException {
      print("Failed parsing inbox");
    }

    for (HistoryItem item in inbox) {
      if (item.reaction is SimpleNotification) {
        SimpleNotification simple = item.reaction;
        print(simple.notificationMessage);
      } else if (item.reaction is CustomJSON) {
        CustomJSON customJSON = item.reaction;
        print(customJSON.notificationMessage);
        print(customJSON.content);
      } else if (item.reaction is Content) {
        Content content = item.reaction;
        print(content.notificationMessage);
        print("Title:" + content.title);
        print("Content:" + content.content);
        print("Image:" + content.image?.fullSize);
        print(content.cta?.label);
        print(content.cta?.url);
      } else if (item.reaction is NearItFeedback) {
        NearItFeedback feedback = item.reaction;
        print(feedback.notificationMessage);
        print(feedback.question);
        print(feedback.trackingInfo.metadata);
        NearitSdk.sendTracking(feedback.trackingInfo, "event");
      }
    }
  }

  getCoupons() async {
    List<Coupon> couponList;
    try {
      couponList = await NearitSdk.getCoupons();
    } on PlatformException {
      print("Failed parsing coupons");
    }

    if (couponList.isNotEmpty) {
      Coupon coupon = couponList[0];
      print("Title: "+ coupon.title);
      print("Description: "+ coupon.description);
      print("Value: "+ coupon.value);
      print("ClaimedAt: "+ coupon.claimedAt);
      var exp = coupon.expiresAt ?? "";
      print("ExpiresAt: "+ exp);
      var redeemableFrom = coupon.redeemableFrom ?? "";
      print("ReedemableFrom: "+ redeemableFrom);
      var redeemedAt = coupon.redeemedAt ?? "";
      print("ReedemableAt: "+ redeemedAt);
      print("Image: "+ coupon.image.fullSize);
    }
  }

  triggerInAppEvent() async {
    NearitSdk.triggerInAppEvent("in_app_event_test");
  }

  triggerContent() async {
    NearitSdk.triggerInAppEvent("content");
  }

  triggerFeedback() async {
    NearitSdk.triggerInAppEvent("feedback");
  }

  triggerCustomJson() async {
    NearitSdk.triggerInAppEvent("json");
  }

  triggerCoupon() async {
    NearitSdk.triggerInAppEvent("coupon");
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('NearItSDK Plugin sample app'),
        ),
        body: new Container(
          padding: const EdgeInsets.all(32.0),
          child: new Flex(
            direction: Axis.vertical,
            children: [
              new Center(
                  child: new Column(
                children: [
                  new Text('ProfileId: $_profileId'),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new RaisedButton(
                      child: const Text('START RADAR'),
                      onPressed: NearitSdk.startRadar,
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new RaisedButton(
                        child: const Text('STOP RADAR'),
                        onPressed: NearitSdk.stopRadar),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new RaisedButton(
                        child: const Text('RESET PROFILE ID'),
                        onPressed: resetProfileId),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new RaisedButton(
                        child: const Text('GET INBOX'), onPressed: getNotificationHistory),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new RaisedButton(
                        child: const Text('GET COUPONS'),
                        onPressed: getCoupons),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new Flex(
                      direction: Axis.horizontal,
                      children: [
                        new Flexible(
                          child: new TextField(
                            controller: myController,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Please, enter a profileId'),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(left: 5.0),
                          child: new RaisedButton(
                              child: const Text('SET PROFILE ID'),
                              onPressed: setProfileId),
                        )
                      ],
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 5.0),
                    child: new Flex(
                      direction: Axis.horizontal,
                      children: [
                        new Flexible(
                          child: new TextField(
                            controller: keyController,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'key'),
                          ),
                        ),
                        new Flexible(
                          child: new TextField(
                            controller: valueController,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: 'value'),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(left: 5.0),
                          child: new RaisedButton(
                              child: const Text('SET USER DATA'),
                              onPressed: setUserData),
                        )
                      ],
                    ),
                  ),
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: new RaisedButton(
                          child: const Text('TRIGGER SIMPLE'),
                          onPressed: triggerInAppEvent),
                  ),
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: new RaisedButton(
                          child: const Text('TRIGGER CONTENT'),
                          onPressed: triggerContent),
                  ),
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: new RaisedButton(
                          child: const Text('TRIGGER FEEDBACK'),
                          onPressed: triggerFeedback),
                  ),
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: new RaisedButton(
                          child: const Text('TRIGGER CUSTOMJSON'),
                          onPressed: triggerCustomJson),
                  ),
                  new Padding(
                      padding: new EdgeInsets.only(top: 5.0),
                      child: new RaisedButton(
                          child: const Text('TRIGGER COUPON'),
                          onPressed: triggerCoupon),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
