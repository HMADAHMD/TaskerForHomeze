import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/screens/assigned_task_card.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/models/tasker.dart' as model;
import 'package:provider/provider.dart';

class AssignedTaskScreen extends StatefulWidget {
  const AssignedTaskScreen({super.key});

  @override
  State<AssignedTaskScreen> createState() => _AssignedTaskScreenState();
}

class _AssignedTaskScreenState extends State<AssignedTaskScreen> {
  @override
  Widget build(BuildContext context) {
    model.Tasker tasker = Provider.of<TaskerProvider>(context).getTasker;
    return Scaffold(
      body: Container(
        color: darkgray,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('taskers')
              .doc(tasker.uid.toString())
              .collection('assignedTasks')
              .snapshots(),
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
                child: ATaskCard(
                  snap: snapshot.data!.docs[index].data(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
