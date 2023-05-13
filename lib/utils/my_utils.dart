import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

class Utils {
  StreamSubscription? _subscription;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //..........................................makes driver offline
  driverIsOffline() async {
    // User currentTasker = _auth.currentUser!;
    // String uid = currentTasker.uid;
    // DocumentSnapshot currentTaskerSnapshot = await FirebaseFirestore.instance
    //     .collection("activeTaskers")
    //     .doc(uid)
    //     .get();
    // if (currentTaskerSnapshot.exists) {
    //   await currentTaskerSnapshot.reference.delete();
    // }
    // DocumentReference taskerRef = _firestore.collection('taskers').doc(uid);
    // await taskerRef.update({'newRideStatus': FieldValue.delete()});
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      restartApp();
    }
  }

  //............................restart
  void restartApp() async {
    const platform = const MethodChannel('com.example.myapp/restart');
    try {
      await platform.invokeMethod('restart');
    } on PlatformException catch (e) {
      print('Failed to restart app: ${e.message}');
    }
  }

}
