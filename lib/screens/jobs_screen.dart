import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/resources/firestore_methods.dart';
import 'package:homezetasker/screens/chatroom.dart';
import 'package:homezetasker/screens/jobs_card.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:homezetasker/models/tasker.dart' as model;

class PostedJobs extends StatefulWidget {
  const PostedJobs({super.key});

  @override
  State<PostedJobs> createState() => _PostedJobsState();
}

class _PostedJobsState extends State<PostedJobs> {
  sendMessage(String userName) {
    print(userName);
    model.Tasker tasker =
        Provider.of<TaskerProvider>(context, listen: false).getTasker;
    List<String> users = [tasker.fullname, userName];

    String chatRoomId = getChatRoomId(tasker.fullname, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    FirestoreMethods().addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkgray,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: orangeclr,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(),
                child: JobsCard(
                  snap: snapshot.data!.docs[index].data(),
                  sendMessage: sendMessage,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
