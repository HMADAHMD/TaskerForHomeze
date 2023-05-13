import 'package:cloud_firestore/cloud_firestore.dart';

class TaskOffer {
  final String fullname;
  final String offerPrice;
  final String profession;
  final String photoURL;
  final String uid;
  final String offerId;

  const TaskOffer(
      {required this.fullname,
      required this.offerPrice,
      required this.profession,
      required this.photoURL,
      required this.uid,
      required this.offerId});

  Map<String, dynamic> toJson() => {
        'fullname': fullname,
        'offerPrice': offerPrice,
        'profession': profession,
        'photoURL': photoURL,
        'uid': uid,
        'offerId': offerId,
      };

  static TaskOffer getUser(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return TaskOffer(
      fullname: snap['fullname'],
      offerPrice: snap['offerPrice'],
      profession: snap['profession'],
      photoURL: snap['photoURL'],
      uid: snap['uid'],
      offerId: snap['offerId'],
    );
  }
}
