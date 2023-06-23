import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homezetasker/global/global.dart';
import 'package:homezetasker/models/directions_detail_info.dart';
import 'package:homezetasker/resources/http_request.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<DirectionDetailsInfo?>
      obtainOriginToDestinationDirectionDetails(
          LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$map_keys";

    var responseDirectionApi = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionApi == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points =
        responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(tasker.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
        tasker.uid, taskerPosition!.latitude, taskerPosition!.longitude);
  }

  static sendNotificationToTaskerNow(
      String deviceRegistrationToken, String userTaskRequestId, context) async {
    // var destinationAddress = Provider.of<UserProvider>(context, listen: false).useraddress;
    //notification header
    Map<String, String> headerNotification = {
      "Content-Type": "application/json",
      "Authorization": cloudMessagingServerToken,
    };

    //notification body
    Map<String, String> bodyNotification = {
      "title": "Homeze",
      "body": "Bargain request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": 1,
      "status": "done",
      "tasksRequestId": userTaskRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat));
  }
}
