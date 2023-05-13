import 'package:flutter/material.dart';
import 'package:homezetasker/screens/assigned_tasks.dart';
import 'package:homezetasker/screens/completed_tasks.dart';
import 'package:homezetasker/screens/jobs_screen.dart';
import 'package:homezetasker/utils/constants.dart';

class TasksTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // number of tabs
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: skyclr,
          title: const Text(
            'Tasks',
            style: TextStyle(
                color: blueclr, fontSize: 22, fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            labelColor: blueclr,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: orangeclr,
            tabs: [
              Tab(text: 'Tasks'),
              Tab(text: 'Assigned'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PostedJobs(),
            AssignedTaskScreen(),
            CompletedTask(),
          ],
        ),
      ),
    );
  }
}
