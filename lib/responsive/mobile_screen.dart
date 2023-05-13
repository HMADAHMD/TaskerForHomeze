import 'package:flutter/material.dart';
import 'package:homezetasker/screens/earning_screen.dart';
import 'package:homezetasker/screens/home_screen.dart';
import 'package:homezetasker/screens/profile_screen.dart';
import 'package:homezetasker/screens/ratings_screen.dart';
import 'package:homezetasker/utils/bottom_tabs.dart';
import 'package:homezetasker/utils/constants.dart';

class MobileScreen extends StatefulWidget {
  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  //method to get access to the collection and then getting the username

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationTabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: blueclr,
        unselectedItemColor: Colors.grey[750],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_sharp),
            label: 'Earning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
