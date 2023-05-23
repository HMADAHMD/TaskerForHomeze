import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homezetasker/models/user_task_request.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/global.dart';
import 'package:homezetasker/widgets/progress_dialogue.dart';
import 'package:provider/provider.dart';

class NewWorkLocationScreen extends StatefulWidget {
  UserTaskRequest? userTaskRequest;
  NewWorkLocationScreen({super.key, this.userTaskRequest});

  @override
  State<NewWorkLocationScreen> createState() => _NewWorkLocationScreenState();
}

class _NewWorkLocationScreenState extends State<NewWorkLocationScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? destinationMapController;
  StreamSubscription<Position>? _streamSubscription;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.33802241013048, 74.36075742817873),
    zoom: 14.4746,
  );
  String? buttonTitle = "Arrived";
  Color? buttonColor = orangeclr;

  Set<Marker> setOfMarkers = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
              destinationMapController = controller;


              var taskerCurrentLatLng = LatLng(taskerPosition!.latitude, taskerPosition!.longitude);

              var workLocationLatLng = widget.userTaskRequest!.workLocationLatLng;
            },
          ),
          //User Interface
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: skyclr,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 18,
                    spreadRadius: .5,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    //duration
                    // const Text(
                    //   "18 mins",
                    //   style:  TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.lightGreenAccent,
                    //   ),
                    // ),

                    const SizedBox(
                      height: 18,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: blueclr,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    //user name - icon
                    Row(
                      children: [
                        Text(
                          widget.userTaskRequest!.userName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: orangeclr,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.phone_iphone,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    //user worklocationAddress with icon
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/destination.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(
                          width: 14,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userTaskRequest!.workLocationAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: blueclr,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),

                    const SizedBox(
                      height: 24,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 2,
                      color: blueclr,
                    ),

                    const SizedBox(height: 10.0),

                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: orangeclr,
                      ),
                      icon: const Icon(
                        Icons.handyman_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
