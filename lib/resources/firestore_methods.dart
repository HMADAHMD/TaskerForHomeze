import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homezetasker/models/task_offer.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> makeOffer(
      String fullname,
      String offerPrice,
      String profession,
      String photoURL,
      String uid,
      String taskId) async {
    String res = 'Some Error Ocurred';
    try {
      String offerId = const Uuid().v1();
      TaskOffer offer = TaskOffer(
        fullname: fullname,
        offerPrice: offerPrice,
        profession: profession,
        photoURL: photoURL,
        uid: uid,
        offerId: offerId,
      );
      //_firestore.collection('tasks').doc(taskId).set(post.toJson());
      _firestore
          .collection('tasks')
          .doc(taskId)
          .collection('offers')
          .doc(offerId)
          .set(offer.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
