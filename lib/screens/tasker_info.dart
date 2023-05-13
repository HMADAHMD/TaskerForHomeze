import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homezetasker/responsive/responsive_screen.dart';
import 'package:homezetasker/screens/login_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/widgets/small_widgets.dart';

class TaskerInfo extends StatefulWidget {
  @override
  State<TaskerInfo> createState() => _TaskerInfoState();
}

class _TaskerInfoState extends State<TaskerInfo> {
  final _profController = TextEditingController();

  final _placeController = TextEditingController();

  final _cnicController = TextEditingController();

  final _numberController = TextEditingController();

  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                "assets/images/Login.jpg",
                height: 250,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Bringing convenience to your doorstep\none tap at a time!",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: blueclr,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    MyTextfield(
                        hintText: 'profession',
                        keyboaredType: TextInputType.name,
                        mycontroller: _profController,
                        correction: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                        hintText: 'place of work',
                        keyboaredType: TextInputType.name,
                        mycontroller: _placeController,
                        correction: false),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                      hintText: 'CNIC',
                      keyboaredType: TextInputType.name,
                      mycontroller: _cnicController,
                      correction: false,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextfield(
                        hintText: 'years of expereince',
                        keyboaredType: TextInputType.number,
                        mycontroller: _numberController,
                        correction: false)
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 70,
                child: MyTextButtons(
                    name: 'SignUp',
                    myOnPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ResponsiveScreen()));
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: blueclr),
                    ),
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(color: orangeclr),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          })
                  ]),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
