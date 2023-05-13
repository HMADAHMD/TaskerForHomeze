import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homezetasker/screens/login_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/my_utils.dart';
import 'package:homezetasker/widgets/small_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //const ProfileScreen({super.key});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Utils myUtils = Utils();

  logoutButton() async {
    await _auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                color: grayclr,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(NewUser),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Josh Redim",
                          style: TextStyle(
                              fontSize: 30,
                              color: orangeclr,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'josh.redd@gmail.com',
                          style: TextStyle(fontSize: 15, color: blueclr),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('923000000000',
                            style: TextStyle(fontSize: 15, color: blueclr)),
                      ],
                    )
                  ],
                ),
              )),
          Container(
            height: 1,
            color: blueclr,
          ),
          Flexible(
              flex: 3,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      ListItems(
                          listName: 'Account',
                          listIcon: const Icon(
                            Icons.person,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'About Us',
                          listIcon: const Icon(
                            Icons.info,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Invite Friends',
                          listIcon: const Icon(
                            Icons.share,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Wallet',
                          listIcon: const Icon(
                            Icons.wallet,
                            size: 40,
                          )),
                      ListItems(
                          listName: 'Privacy Policy',
                          listIcon: const Icon(
                            Icons.lock_outline_rounded,
                            size: 40,
                          )),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Logout'),
                                content:
                                    Text('Are you sure you want to Logout?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      // Perform some action
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: blueclr),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      //myUtils.driverIsOffline();
                                      logoutButton();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: ListItems(
                            listName: 'Log Out',
                            listIcon: const Icon(
                              Icons.logout_outlined,
                              size: 40,
                            )),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}
