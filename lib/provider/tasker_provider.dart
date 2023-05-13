import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homezetasker/models/directions.dart';
import 'package:homezetasker/models/tasker.dart';
import 'package:homezetasker/resources/auth_methods.dart';

class TaskerProvider extends ChangeNotifier {
  Tasker? _tasker;
  final AuthMethods _authMethods = AuthMethods();

  Tasker get getTasker => _tasker!;

  Directions? useraddress;
  void updateUserAddress(Directions userAddress) {
    useraddress = userAddress;
  }

  Future<void> refreshTasker() async {
    Tasker tasker = await _authMethods.getTaskerDetails();
    _tasker = tasker;
    notifyListeners();
  }
}
