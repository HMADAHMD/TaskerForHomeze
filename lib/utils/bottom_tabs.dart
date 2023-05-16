import 'package:flutter/material.dart';
import 'package:homezetasker/screens/earning_screen.dart';
import 'package:homezetasker/screens/home_screen.dart';
import 'package:homezetasker/screens/profile_screen.dart';
import 'package:homezetasker/screens/ratings_screen.dart';
import 'package:homezetasker/screens/tasks_tab_bar.dart';

List<Widget> navigationTabs = [
  HomeScreen(),
  EarningScreen(),
  RatingScreen(),
  TasksTabBar(),
  ProfileScreen()
];
