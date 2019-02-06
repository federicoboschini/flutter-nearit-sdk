import 'package:nearit_sdk/objects/Event.dart';
import 'package:nearit_sdk/objects/NearItFeedback.dart';
import 'package:nearit_sdk/objects/TrackingInfo.dart';

class FeedbackEvent extends Event {

  final String PLUGIN_NAME = "FeedbackEvent";

  String feedbackId;
  int rating;
  String comment;
  TrackingInfo trackingInfo;


  FeedbackEvent(NearItFeedback feedback, int rating, String comment) {
    this.feedbackId = feedback.recipeId;
    this.rating = rating;
    this.comment = comment;
    this.trackingInfo = feedback.trackingInfo;
  }

  String get id => this.feedbackId;

  @override
  String getPlugin() {
    return PLUGIN_NAME;
  }

}