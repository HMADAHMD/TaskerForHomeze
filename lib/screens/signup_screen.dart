import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homezetasker/global/global.dart';
import 'package:homezetasker/resources/auth_methods.dart';
import 'package:homezetasker/responsive/responsive_screen.dart';
import 'package:homezetasker/screens/home_screen.dart';
import 'package:homezetasker/screens/login_screen.dart';
import 'package:homezetasker/screens/tasker_info.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/utils.dart';
import 'package:homezetasker/widgets/small_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<String> _professionList = [
    'Plumber',
    'Electrician',
    'Carpenter',
    'Painter',
    'Cleaning',
    'Gardener',
    'Labor'
  ];
  String? _profSelected;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numberController = TextEditingController();
  final _placeController = TextEditingController();
  final _cnicController = TextEditingController();
  final _expController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _numberController.dispose();
    _placeController.dispose();
    _cnicController.dispose();
    _expController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  validateForm() {
    if (_nameController.text.length < 3) {
      Fluttertoast.showToast(msg: 'Name must be atleast 4 characters');
    } else if (_passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Password must be atleast 6 characters long');
    } else if (_numberController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Phone number is required');
    } else if (_expController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Experience is required');
    } else if (_placeController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'City is required');
    } else if (_cnicController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'CNIC is required');
    } else if (_expController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Experience is Required');
    } else if (!_emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: 'Email address is not valid');
    } else {
      signUpUser();
      //savetaskerInfo();
    }
  }

  savetaskerInfo() async {
    final _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String uid = user.uid;
    final fUser = uid;

    if (fUser != null) {
      Map taskerMap = {
        "id": fUser,
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "phone": _numberController.text.trim(),
      };
      DatabaseReference taskerRef =
          FirebaseDatabase.instance.ref().child('tasker');
      taskerRef.child(fUser).set(taskerMap).then((_) {
        Map taskerInfoMap = {
          "city": _placeController.text.trim(),
          "cnic": _cnicController.text.trim(),
          "experience": _expController.text.trim(),
          "profession": _profSelected,
        };
        taskerRef.child(fUser).child("profession").set(taskerInfoMap);
      }).catchError((error) {
        Fluttertoast.showToast(msg: 'Error: $error');
      });
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    } else {
      Fluttertoast.showToast(msg: 'Account has not been created');
    }
  }

  signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signupUser(
        email: _emailController.text,
        password: _passwordController.text,
        fullname: _nameController.text,
        number: _numberController.text,
        profession: _profSelected!,
        workplace: _placeController.text,
        experience: _expController.text,
        cnic: _cnicController.text,
        file: _image!);
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      savetaskerInfo();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Welcome to Homeze\n Registration",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 30,
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
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 65,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage('assets/images/user_icon.png'),
                                ),
                          Positioned(
                              bottom: -8,
                              left: 85,
                              child: IconButton(
                                  onPressed: () {
                                    selectImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.grey,
                                  )))
                        ],
                      ),
                      MyTextfield(
                          hintText: 'fullname',
                          keyboaredType: TextInputType.name,
                          mycontroller: _nameController,
                          correction: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                          hintText: 'email',
                          keyboaredType: TextInputType.emailAddress,
                          mycontroller: _emailController,
                          correction: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                          hintText: 'number',
                          keyboaredType: TextInputType.number,
                          mycontroller: _numberController,
                          correction: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                          hintText: 'city',
                          keyboaredType: TextInputType.name,
                          mycontroller: _placeController,
                          correction: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                        hintText: 'CNIC',
                        keyboaredType: TextInputType.number,
                        mycontroller: _cnicController,
                        correction: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                          hintText: 'years of expereince',
                          keyboaredType: TextInputType.number,
                          mycontroller: _expController,
                          correction: false),
                      const SizedBox(
                        height: 10,
                      ),
                      MyTextfield(
                        hintText: 'password',
                        keyboaredType: TextInputType.name,
                        mycontroller: _passwordController,
                        correction: false,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DropdownButton(
                        hint: Text(
                          'select your profession',
                          style: TextStyle(color: orangeclr),
                        ),
                        value: _profSelected,
                        items: _professionList.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _profSelected = value!;
                          });
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 70,
                  child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: blueclr,
                            )
                          : MyTextButtons(
                              name: 'SignUp',
                              myOnPressed: () {
                                validateForm();
                              })),
                ),
                const SizedBox(
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
                              navigateToLogin();
                            })
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
