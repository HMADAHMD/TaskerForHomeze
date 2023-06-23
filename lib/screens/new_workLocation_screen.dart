import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homezetasker/models/user_task_request.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/resources/asssitants_methods.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/widgets/fair_amount_collection_dialogue.dart';
import 'package:homezetasker/widgets/progress_dialogue.dart';
import 'package:provider/provider.dart';
import 'package:homezetasker/global/global.dart';

class NewWorkLocationScreen extends StatefulWidget {
  UserTaskRequest? userTaskRequest;
  String? finalPriceValue;
  NewWorkLocationScreen(
      {super.key, this.userTaskRequest, this.finalPriceValue});

  @override
  State<NewWorkLocationScreen> createState() => _NewWorkLocationScreenState();
}

class _NewWorkLocationScreenState extends State<NewWorkLocationScreen> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? destinationMapController;

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
  double mapPadding = 0;
  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;

  BitmapDescriptor? iconAnimatedMarker;
  var geoLocator = Geolocator();
  Position? onlineTaskerCurrentPosition;

  createTaskerIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(3, 3));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/tasker.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistantMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_points);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.e_points!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      decodedPolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: orangeclr,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    destinationMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    Circle originCircle = Circle(
      circleId: const CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.red,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  getTaskerLiveLocationUpdate() {
    LatLng oldLatLng = LatLng(0, 0);
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;
    streamSubscriptionTaskerLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      taskerPosition = position;
      onlineTaskerCurrentPosition = position;

      LatLng latlngTaskerPosition = LatLng(
        onlineTaskerCurrentPosition!.latitude,
        onlineTaskerCurrentPosition!.longitude,
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latlngTaskerPosition,
        icon: iconAnimatedMarker!,
        infoWindow: const InfoWindow(title: "This is your Position"),
      );

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latlngTaskerPosition, zoom: 16);
        destinationMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setOfMarkers.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latlngTaskerPosition;
      updateDurationTimeAtRealTime();

      //updating driver location at real time in Database
      Map taskerLatLngDataMap = {
        "latitude": onlineTaskerCurrentPosition!.latitude.toString(),
        "longitude": onlineTaskerCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance
          .ref()
          .child("tasksRequest")
          .child(widget.userTaskRequest!.taskRequestId!)
          .child("taskerLocation")
          .set(taskerLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;

      if (onlineTaskerCurrentPosition == null) {
        return;
      }

      var originLatLng = LatLng(
        onlineTaskerCurrentPosition!.latitude,
        onlineTaskerCurrentPosition!.longitude,
      ); //Tasker current Location

      var destinationLatLng;

      if (rideRequestStatus == "accepted") {
        destinationLatLng = widget.userTaskRequest!
            .workLocationLatLng; //user PickUp Location / worklocation
      } else //arrived
      {
        // destinationLatLng = widget
        //     .userRideRequestDetails!.destinationLatLng; //user DropOff Location
      }

      var directionInformation =
          await AssistantMethods.obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng);

      if (directionInformation != null) {
        setState(() {
          durationFromOriginToDestination = directionInformation.duration_text!;
        });
      }

      isRequestDirectionDetails = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveAssignedTaskerDetails();
  }

  @override
  Widget build(BuildContext context) {
    createTaskerIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
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
              setState(() {
                mapPadding = 350;
              });

              var taskerCurrentLatLng =
                  LatLng(taskerPosition!.latitude, taskerPosition!.longitude);

              var workLocationLatLng =
                  widget.userTaskRequest!.workLocationLatLng;
              drawPolyLineFromOriginToDestination(
                  taskerCurrentLatLng, workLocationLatLng!);
              getTaskerLiveLocationUpdate();
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
                    Text(
                      durationFromOriginToDestination,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blueclr,
                      ),
                    ),

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
                        Text('${widget.userTaskRequest!.userPhone}'),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: grayclr,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Task: ${widget.userTaskRequest!.title!}',
                              style: const TextStyle(
                                  color: blueclr,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Details: ${widget.userTaskRequest!.description!}',
                              style: const TextStyle(
                                  color: blueclr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'Price: ${widget.userTaskRequest!.finalPrice!}',
                              style: const TextStyle(
                                  color: orangeclr,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
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

                    const SizedBox(
                      height: 5.0,
                    ),

                    const Divider(
                      thickness: 2,
                      height: 1,
                      color: blueclr,
                    ),

                    const SizedBox(height: 5.0),

                    ElevatedButton.icon(
                      onPressed: () {
                        //[tasker has arrived at user PickUp Location] - Arrived Button
                        if (rideRequestStatus == "accepted") {
                          rideRequestStatus = "arrived";

                          FirebaseDatabase.instance
                              .ref()
                              .child("tasksRequest")
                              .child(widget.userTaskRequest!.taskRequestId!)
                              .child("status")
                              .set(rideRequestStatus);
                          print(widget.userTaskRequest!.finalPrice!);

                          setState(() {
                            buttonTitle = "Work Started"; //start the trip
                            buttonColor = blueclr;
                          });

                          // showDialog(
                          //     context: context,
                          //     barrierDismissible: false,
                          //     builder: (BuildContext c)=> ProgressDialog(
                          //       message: "Loading...",
                          //     ),
                          // );

                          // await drawPolyLineFromOriginToDestination(
                          //     widget.userRideRequestDetails!.originLatLng!,
                          //     widget.userRideRequestDetails!.destinationLatLng!
                          // );

                          // Navigator.pop(context);
                        }
                        //tasker has reached destination and pressed <<work Started>> - Work started
                        else if (rideRequestStatus == "arrived") {
                          rideRequestStatus = "workStarted";

                          FirebaseDatabase.instance
                              .ref()
                              .child("tasksRequest")
                              .child(widget.userTaskRequest!.taskRequestId!)
                              .child("status")
                              .set(rideRequestStatus);

                          setState(() {
                            buttonTitle = "Work Completed"; //end the trip
                            buttonColor = Colors.deepPurpleAccent;
                          });
                        }
                        //[tasker has completed the work] - Work Completed Button
                        else if (rideRequestStatus == "workStarted") {
                          workConpletedNow();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
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

  workConpletedNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait...",
      ),
    );

    //get the tripDirectionDetails = distance travelled
    var currentTaskerPositionLatLng = LatLng(
      onlineTaskerCurrentPosition!.latitude,
      onlineTaskerCurrentPosition!.longitude,
    );

    String finalPValue = widget.finalPriceValue!;
    double newfinalPriceValue = double.parse(finalPValue);
    double totalFareAmount = newfinalPriceValue;
    FirebaseDatabase.instance
        .ref()
        .child("tasksRequest")
        .child(widget.userTaskRequest!.taskRequestId!)
        .child("fareAmount")
        .set(totalFareAmount.toString());

    FirebaseDatabase.instance
        .ref()
        .child("tasksRequest")
        .child(widget.userTaskRequest!.taskRequestId!)
        .child("status")
        .set("ended");

    streamSubscriptionTaskerLivePosition!.cancel();

    Navigator.pop(context);
    //display fair amount in dialogue box
    showDialog(
        context: context,
        builder: (BuildContext c) =>
            FairAmountCollectionDialogue(totalFareAmount: totalFareAmount));
    //save earnings to tasker total earnings
    saveFareAmountToTaskerEarnings(totalFareAmount);
  }

  saveFareAmountToTaskerEarnings(double totalFareAmount) {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;
    FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double taskerTotalEarnings = oldEarnings + totalFareAmount;

        FirebaseDatabase.instance
            .ref()
            .child("tasker")
            .child(tasker.uid)
            .child("earnings")
            .set(taskerTotalEarnings.toString());
      } else {
        FirebaseDatabase.instance
            .ref()
            .child("tasker")
            .child(tasker.uid)
            .child("earnings")
            .set(totalFareAmount.toString());
      }
    });
  }

  saveAssignedTaskerDetails() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("tasksRequest")
        .child(widget.userTaskRequest!.taskRequestId!);

    Map taskerLocationDataMap = {
      "latitude": taskerPosition!.latitude.toString(),
      "longitude": taskerPosition!.longitude.toString(),
    };
    databaseReference.child("taskerLocation").set(taskerLocationDataMap);
    databaseReference.child("status").set("accepted");
    databaseReference.child("taskerId").set(onlinetaskerData.id);
    databaseReference.child("taskerName").set(onlinetaskerData.name);
    databaseReference.child("taskerPhone").set(onlinetaskerData.phone);
    databaseReference.child("taskerCNIC").set(onlinetaskerData.cnic);
    databaseReference
        .child("taskerExperience")
        .set(onlinetaskerData.experience);
    databaseReference
        .child("taskerProfession")
        .set(onlinetaskerData.profession);
    saveTaskRequestIdToTaskerHistory();
  }

  saveTaskRequestIdToTaskerHistory() {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;
    DatabaseReference tripsHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .child("tasksHistory");

    tripsHistoryRef.child(widget.userTaskRequest!.taskRequestId!).set(true);
  }
}
