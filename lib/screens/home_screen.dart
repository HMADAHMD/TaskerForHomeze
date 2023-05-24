import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/push_notificaions/push_notification_system.dart';
import 'package:homezetasker/resources/http_response.dart';
import 'package:homezetasker/screens/chatrooms_list.dart';
import 'package:homezetasker/screens/profile_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/my_utils.dart';
import 'package:homezetasker/widgets/small_widgets.dart';
import 'package:provider/provider.dart';
import 'package:homezetasker/models/tasker.dart' as model;
import 'package:homezetasker/global/global.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Utils myUtils = Utils();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  GoogleMapController? newMapController;
  StreamSubscription<Position>? _streamSubscription;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(32.33802241013048, 74.36075742817873),
    zoom: 14.4746,
  );

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  checkPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locatePosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    taskerPosition = currentPosition;

    LatLng LatLngPosition =
        LatLng(taskerPosition!.latitude, taskerPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: LatLngPosition, zoom: 14);

    newMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String readableAddress =
        await HttpResponse.responseGot(taskerPosition!, context);
    print('Address: ' + readableAddress);
  }


  readCurrentTaskerInfo() async {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;

    FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlinetaskerData.id = (snap.snapshot.value as Map)["id"];
        onlinetaskerData.email = (snap.snapshot.value as Map)["email"];
        onlinetaskerData.name = (snap.snapshot.value as Map)["name"];
        onlinetaskerData.phone = (snap.snapshot.value as Map)["phone"];
        onlinetaskerData.cnic =
            (snap.snapshot.value as Map)["profession"]["cnic"];
        onlinetaskerData.experience =
            (snap.snapshot.value as Map)["profession"]["experience"];
        onlinetaskerData.profession =
            (snap.snapshot.value as Map)["profession"]["profession"];

        print('Cars Details>>>>>');
        print(onlinetaskerData.id);
        print(onlinetaskerData.name);
        print(onlinetaskerData.phone);
        print(onlinetaskerData.cnic);
        print(onlinetaskerData.experience);
        print(onlinetaskerData.profession);
      } else {
        print('ERROR>>>>>>>>>>>');
      }
    });

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.inittializeCloudMessaging(context);
    pushNotificationSystem.generateTokens();
  }

  @override
  void initState() {
    super.initState();
    // showData();
    checkPermission();
    readCurrentTaskerInfo();
  }

  // String _username = '';
  // String _email = '';
  // String _photoURL = '';

  // //get data from firebasefirestore
  // showData() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   User currentUser = _auth.currentUser!;
  //   final userRef = _firestore.collection('taskers').doc(currentUser.uid);
  //   await userRef.get().then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       Map<String, dynamic> userData =
  //           documentSnapshot.data() as Map<String, dynamic>;
  //       String userName = userData['fullname'];
  //       String email = userData['email'];
  //       String photo = userData['photoURL'];
  //       setState(() {
  //         _username = userName;
  //         _email = email;
  //         _photoURL = photo;
  //       });
  //     }
  //   });
  // }

  bool _isDriverActive = false;
  String statusText = "Now Offline";

  @override
  Widget build(BuildContext context) {
    model.Tasker tasker = Provider.of<TaskerProvider>(context).getTasker;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Provider.of<TaskerProvider>(
                      context,
                    ).useraddress !=
                    null
                ? Provider.of<TaskerProvider>(
                    context,
                  ).useraddress!.locationName!
                : 'Your Location',
            style: TextStyle(
                color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          backgroundColor: skyclr,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(
                  Icons.menu,
                  color: blueclr,
                ));
          }),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatroomsList()));
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: blueclr,
                )),
          ],
          elevation: 1,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: skyclr),
                accountName: Text(
                  tasker.fullname,
                  style: TextStyle(color: blueclr),
                ),
                accountEmail: Text(
                  tasker.email,
                  style: TextStyle(color: blueclr),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(tasker.photoURL.toString()),
                ),
              ),
              ListItems(
                  listName: 'Account',
                  listIcon: const Icon(
                    Icons.person,
                    size: 30,
                  )),
              ListItems(
                  listName: 'About Us',
                  listIcon: const Icon(
                    Icons.info,
                    size: 30,
                  )),
              ListItems(
                  listName: 'Invite Friends',
                  listIcon: const Icon(
                    Icons.share,
                    size: 30,
                  )),
              ListItems(
                  listName: 'Wallet',
                  listIcon: const Icon(
                    Icons.wallet,
                    size: 30,
                  )),
              ListItems(
                  listName: 'Privacy Policy',
                  listIcon: const Icon(
                    Icons.lock_outline_rounded,
                    size: 30,
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: ListItems(
                    listName: 'Profile',
                    listIcon: const Icon(
                      Icons.person,
                      size: 30,
                    )),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: orangeclr,
              child: _isDriverActive
                  ? Container(
                      color: darkgray,
                      child: Stack(
                        children: [
                          Container(
                            child: GoogleMap(
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              zoomControlsEnabled: true,
                              zoomGesturesEnabled: true,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (GoogleMapController controller) {
                                _mapController.complete(controller);
                                newMapController = controller;
                                locatePosition();
                              },
                            ),
                          ),
                          Positioned(
                              top: 5,
                              right: 5,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: orangeclr,
                                      foregroundColor: blueclr),
                                  onPressed: () {
                                    taskerIsOffline();
                                    setState(() {
                                      _isDriverActive = false;
                                    });
                                  },
                                  child: Text('Go Offline'))),
                        ],
                      ),
                    )
                  : Container(
                      color: darkgray,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'You are offline',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                                color: blueclr),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: orangeclr,
                                  foregroundColor: blueclr),
                              onPressed: () {
                                taskerIsOnline();
                                updateTaskerLocation();
                                setState(() {
                                  _isDriverActive = true;
                                });
                              },
                              child: Text(
                                'Go Online',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      )),
                    ),
            ),
          ],
        ));
  }

//..........................................makes driver online and store driver geolocation in firestore
  taskerIsOnline() async {
    final _auth = FirebaseAuth.instance;
    User tasker = _auth.currentUser!;

    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    taskerPosition = pos;

    Geofire.initialize('activeTaskers');
    Geofire.setLocation(
      tasker.uid,
      taskerPosition!.latitude,
      taskerPosition!.longitude,
    );

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .child("taskerStatus");
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updateTaskerLocation() {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;
    _streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      taskerPosition = position;
      Geofire.setLocation(
        tasker.uid,
        taskerPosition!.latitude,
        taskerPosition!.longitude,
      );

      LatLng latlng =
          LatLng(taskerPosition!.latitude, taskerPosition!.longitude);
      newMapController!.animateCamera(CameraUpdate.newLatLng(latlng));
    });
  }

  taskerIsOffline() {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;
    Geofire.removeLocation(tasker.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .child("taskerStatus");
    ref.onDisconnect;
    ref.remove();
    ref = null;
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      restartApp();
    }
  }

  void restartApp() async {
    const platform = const MethodChannel('com.example.myapp/restart');
    try {
      await platform.invokeMethod('restart');
    } on PlatformException catch (e) {
      print('Failed to restart app: ${e.message}');
    }
  }
}





  //taskerIsOnline() async {
  // Position pos = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high);
  // taskerPosition = pos;
  // final _auth = FirebaseAuth.instance;
  // User user = _auth.currentUser!;
  // String uid = user.uid;
  // Geofire.initialize('activeTaskers');
  // Geofire.setLocation(
  //     uid, taskerPosition!.latitude, taskerPosition!.longitude);

  // DatabaseReference ref = FirebaseDatabase.instance
  //     .ref()
  //     .child('tasker')
  //     .child(uid)
  //     .child('newTaskerStatus');
  // ref.set('idle');
  // ref.onValue.listen((event) {});
  //}
  // driverIsOnline() async {
  //   User currentTasker = _auth.currentUser!;
  //   String uid = currentTasker.uid;

  //   Position pos = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   userPosition = pos;

  //   GeoFirePoint point = geo.point(
  //       latitude: userPosition!.latitude, longitude: userPosition!.longitude);

  //   DocumentReference taskerRef =
  //       _firestore.collection('activeTaskers').doc(uid);
  //   await taskerRef.set({
  //     'position': point.data,
  //   });
  //   DocumentReference tasker = _firestore.collection('taskers').doc(uid);
  //   Map<String, dynamic> newData = {'newRideStatus': 'idle'};
  //   await tasker.set(newData, SetOptions(merge: true));
  // }

  //..........................................gets driver realtime location

  // realtimeLocation() async {
  //   User currentTasker = _auth.currentUser!;
  //   String uid = currentTasker.uid;
  //   _subscription =
  //       Geolocator.getPositionStream().listen((Position position) async {
  //     userPosition = position;
  //     if (_isDriverActive == true) {
  //       GeoFirePoint point = geo.point(
  //           latitude: userPosition!.latitude,
  //           longitude: userPosition!.longitude);
  //       DocumentReference taskerRef =
  //           _firestore.collection('activeTaskers').doc(uid);
  //       await taskerRef.set({
  //         'position': point.data,
  //       });
  //     }
  //     LatLng latLng = LatLng(userPosition!.latitude, userPosition!.longitude);
  //     newMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
  //   });
  // }
