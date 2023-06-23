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
String cloudMessagingServerToken =
    "key=AAAAQ3Gq2f8:APA91bHl_H63FMkhhEZKaooSZyl5tPNjf2RjXS62_JAwf1ZPDtLCkJFOLZeghG9bQZcoPHJkmjM9hrmBwIwo_-hTU2MBrUvIYo936iyoEeKT9V3fp7ow5udyJNQNgqCRzhSHj-1ziS8r";
