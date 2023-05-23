import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homezetasker/models/user_task_request.dart';
import 'package:homezetasker/screens/new_workLocation_screen.dart';
import 'package:homezetasker/utils/constants.dart';

class NotificationDialogueBox extends StatefulWidget {
  UserTaskRequest? userTaskRequest;
  NotificationDialogueBox({super.key, this.userTaskRequest});

  @override
  State<NotificationDialogueBox> createState() =>
      _NotificationDialogueBoxState();
}

class _NotificationDialogueBoxState extends State<NotificationDialogueBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 3,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: skyclr,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 14,
            ),
            Image.asset(
              'assets/images/work.webp',
              width: 160,
            ),
            const SizedBox(
              height: 10,
            ),

            //title
            const Text(
              "New Task Request",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22, color: blueclr),
            ),
            const SizedBox(height: 14.0),

            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  //workLocation with icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userTaskRequest!.workLocationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: skyclr,
                        elevation: 0),
                    onPressed: () {
                      // audioPlayer.pause();
                      // audioPlayer.stop();
                      // audioPlayer = AssetsAudioPlayer();

                      //cancel the rideRequest

                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 25.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeclr,
                    ),
                    onPressed: () {
                      // audioPlayer.pause();
                      // audioPlayer.stop();
                      // audioPlayer = AssetsAudioPlayer();

                      //accept the rideRequest
                      acceptTaskRequest(context);

                      // Navigator.pop(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  acceptTaskRequest(BuildContext context) {
    final auth = FirebaseAuth.instance;
    User tasker = auth.currentUser!;

    String getTaskRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(tasker.uid)
        .child("taskerStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getTaskRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: 'This task Request does not existss');
      }

      

      if (getTaskRequestId == widget.userTaskRequest!.taskRequestId) {
        // send driver to new ride screen
        FirebaseDatabase.instance
            .ref()
            .child("tasker")
            .child(tasker.uid)
            .child("taskerStatus")
            .set('accepted');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewWorkLocationScreen(
                    userTaskRequest: widget.userTaskRequest)));
      } else {
        Fluttertoast.showToast(msg: 'This task Request does not exists');
      }
    });
  }
}
