import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nearit_sdk/nearit_sdk.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _profileId = 'Unknown';

  final myController = new TextEditingController();

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

  getInbox() {
    NearitSdk
        .getInbox()
        .then((inbox) => print("Inbox: " + inbox.toString()))
        .catchError((error) => print(error));
  }

  getCoupons() {
    NearitSdk
        .getCoupons()
        .then((copuns) => print("Coupons: " + copuns.toString()))
        .catchError((error) => print(error));
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
                        child: const Text('GET INBOX'), onPressed: getInbox),
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
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
