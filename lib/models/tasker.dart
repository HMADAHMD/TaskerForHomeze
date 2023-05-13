import 'package:cloud_firestore/cloud_firestore.dart';

class Tasker {
  final String fullname;
  final String email;
  final String number;
  final String uid;
  final String profession;
  final String workplace;
  final String experience;
  final String cnic;
  final String photoURL;

  const Tasker({
    required this.fullname,
    required this.email,
    required this.number,
    required this.uid,
    required this.profession,
    required this.workplace,
    required this.experience,
    required this.cnic,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'email': email,
        'number': number,
        'uid': uid,
        'profession': profession,
        'workplace': workplace,
        'experience': experience,
        'cnic': cnic,
        'photoURL': photoURL,
      };

  static Tasker getTasker(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Tasker(
        fullname: snap['fullname'],
        email: snap['email'],
        number: snap['number'],
        uid: snap['uid'],
        profession: snap['profession'],
        workplace: snap['workplace'],
        experience: snap['experience'],
        cnic: snap['cnic'],
        photoURL: snap['photoURL']);
  }
}
