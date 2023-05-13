import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homezetasker/resources/storage_methods.dart';
import 'package:homezetasker/models/tasker.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserCredential? cred;

  Future<model.Tasker> getTaskerDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('taskers').doc(currentUser.uid).get();

    return model.Tasker.getTasker(documentSnapshot);
  }

  //signup tasker
  Future<String> signupUser(
      {required String email,
      required String password,
      required String fullname,
      required String number,
      required String profession,
      required String workplace,
      required String experience,
      required String cnic,
      required Uint8List file}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          number.isNotEmpty ||
          fullname.isNotEmpty ||
          file != null) {
        //only this(email and password) will be stored in firebase auth rest of it will be stored in FirebaseFirestore
        cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //print(cred!.user!.uid);

        String photoURL =
            await StorageMethod().uploadImage('profilePics', file);

        model.Tasker tasker = model.Tasker(
            fullname: fullname,
            email: email,
            number: number,
            uid: cred!.user!.uid,
            profession: profession,
            workplace: workplace,
            experience: experience,
            cnic: cnic,
            photoURL: photoURL);

        //create a user in db
        await _firestore
            .collection('taskers')
            .doc(cred!.user!.uid)
            .set(tasker.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //login user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some Error Occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
