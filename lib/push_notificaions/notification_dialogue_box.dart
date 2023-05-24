import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:homezetasker/global/global.dart';
import 'package:homezetasker/models/user_task_request.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/resources/asssitants_methods.dart';
import 'package:homezetasker/screens/new_workLocation_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/models/tasker.dart' as model;
import 'package:provider/provider.dart';

class NotificationDialogueBox extends StatefulWidget {
  UserTaskRequest? userTaskRequest;
  NotificationDialogueBox({super.key, this.userTaskRequest});

  @override
  State<NotificationDialogueBox> createState() =>
      _NotificationDialogueBoxState();
}

class _NotificationDialogueBoxState extends State<NotificationDialogueBox> {
  String bargainPrice = '';
  final _bargainPricecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkValueChanges();
  }

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
            const SizedBox(height: 14.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task: ${widget.userTaskRequest!.title!}',
                    style: const TextStyle(
                        color: blueclr,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Details: ${widget.userTaskRequest!.description!} dsbfjksbfkjsdjvklsdklvbsdlkbvkldbsnklbvjbsdvkjb kjdsbv',
                    style: const TextStyle(
                        color: blueclr,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  Text(
                    'Price: ${widget.userTaskRequest!.price!}',
                    style: const TextStyle(
                        color: orangeclr,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
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
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: blueclr,
                      ),
                      onPressed: () {
                        // audioPlayer.pause();
                        // audioPlayer.stop();
                        // audioPlayer = AssetsAudioPlayer();

                        //accept the rideRequest
                        // acceptTaskRequest(context);

                        //bargain the price
                        myAlertView();

                        // Navigator.pop(context);
                      },
                      child: Text(
                        "Bargain".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: ElevatedButton(
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
        AssistantMethods.pauseLiveLocationUpdates();
      } else {
        Fluttertoast.showToast(msg: 'This task Request does not exists');
      }
    });
  }

  checkValueChanges() {
    String finalPrice = '';
    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child("tasksRequest")
        .child(widget.userTaskRequest!.taskRequestId!)
        .child('finalPrice');
    reference.onValue.listen((event) {
      if (event.snapshot.value != "") {
        finalPrice = event.snapshot.value as String;
      }
      if (finalPrice.isNotEmpty) {
        // Perform your desired actions here when the value changes
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewWorkLocationScreen(
                    userTaskRequest: widget.userTaskRequest)));
        AssistantMethods.pauseLiveLocationUpdates();
        print('Value changed: $finalPrice');
      }
    });
  }

  bargainTaskPrice(BuildContext context) {
    // model.Tasker tasker =
    //     Provider.of<TaskerProvider>(context, listen: false).getTasker;
    final auth = FirebaseAuth.instance;
    User taskerId = auth.currentUser!;
    // 1. save bargain price under specific task request
    String getTaskRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("tasker")
        .child(taskerId.uid)
        .child("taskerStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getTaskRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(
            msg: 'This Bargain TASK Request does not existss');
      }
      if (getTaskRequestId == widget.userTaskRequest!.taskRequestId) {
        // send driver to new ride screen
        FirebaseDatabase.instance
            .ref()
            .child("tasksRequest")
            .child(getTaskRequestId)
            .child("bargainPrice")
            .set(bargainPrice);
        DatabaseReference databaseReference = FirebaseDatabase.instance
            .ref()
            .child("tasksRequest")
            .child(widget.userTaskRequest!.taskRequestId!);
        databaseReference.child("taskerId").set(onlinetaskerData.id);
      } else {
        Fluttertoast.showToast(msg: 'This task Request does not exists');
      }
    });
  }

  myAlertView() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add price'),
          content: TextField(
            controller: _bargainPricecontroller,
            autocorrect: false,
            keyboardType: TextInputType.number,
            cursorColor: orangeclr,
            decoration: const InputDecoration(
                hintText: "add your price",
                fillColor: grayclr,
                filled: true,
                enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: darkgray)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: orangeclr))),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  bargainPrice = _bargainPricecontroller.text;
                });
                bargainTaskPrice(context);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Done',
                style: TextStyle(color: blueclr),
              ),
            ),
          ],
        );
      },
    );
  }
}
