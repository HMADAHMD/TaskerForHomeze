import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserTaskRequest {
  String? userName;
  String? userPhone;
  String? taskRequestId;
  String? workLocationAddress;
  LatLng? workLocationLatLng;

  UserTaskRequest({
    this.userName,
    this.userPhone,
    this.taskRequestId,
    this.workLocationAddress,
    this.workLocationLatLng,
  });
}
