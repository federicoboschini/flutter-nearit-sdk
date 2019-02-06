import 'dart:collection';

import 'package:nearit_sdk/objects/ReactionBundle.dart';
import 'package:nearit_sdk/objects/TrackingInfo.dart';

class NearItFeedback extends ReactionBundle {

  String _recipeId;
  String question;
  TrackingInfo trackingInfo;

  NearItFeedback(LinkedHashMap map) : super(map) {
    question = map['question'];
    trackingInfo = TrackingInfo(map['trackingInfo']);
  }

  String get recipeId => this._recipeId;
}