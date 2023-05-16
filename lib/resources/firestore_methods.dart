import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homezetasker/models/task_offer.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> makeOffer(String fullname, String offerPrice,
      String profession, String photoURL, String uid, String taskId) async {
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

//used in chatroom_list
  getUserChats(String itIsMyName) async {
    return _firestore
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  addChatRoom(chatRoom, chatRoomId) async {
    _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return _firestore
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }
}
