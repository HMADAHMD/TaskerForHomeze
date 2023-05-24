import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homezetasker/models/tasker_data.dart';

Position? taskerPosition;
final FirebaseAuth fAuth = FirebaseAuth.instance;
TaskerData onlinetaskerData = TaskerData();
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionTaskerLivePosition;
final auth = FirebaseAuth.instance;
User tasker = auth.currentUser!;
