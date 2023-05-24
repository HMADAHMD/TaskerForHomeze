import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserTaskRequest {
  String? userName;
  String? userPhone;
  String? taskRequestId;
  String? workLocationAddress;
  LatLng? workLocationLatLng;
  String? title;
  String? description;
  String? price;
  String? bargainPrice;
  String? finalPrice;

  UserTaskRequest({
    this.userName,
    this.userPhone,
    this.taskRequestId,
    this.workLocationAddress,
    this.workLocationLatLng,
    this.title,
    this.description,
    this.price,
    this.bargainPrice,
    this.finalPrice
  });
}
