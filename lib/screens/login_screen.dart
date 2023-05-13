import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homezetasker/resources/auth_methods.dart';
import 'package:homezetasker/responsive/responsive_screen.dart';
import 'package:homezetasker/screens/signup_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:homezetasker/utils/utils.dart';
import 'package:homezetasker/widgets/small_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ResponsiveScreen()));
    }
  }

  void navigateToSignUp() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Image.asset("assets/images/Login.jpg"),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Login",
                style: GoogleFonts.poppins(
                  color: blueclr,
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(),
                          child: MyTextfield(
                              hintText: 'email',
                              keyboaredType: TextInputType.emailAddress,
                              mycontroller: _emailController,
                              correction: false),
                        ),
                        Container(
                            padding: const EdgeInsets.all(8.0),
                            child: MyTextfield(
                              hintText: 'password',
                              keyboaredType: TextInputType.name,
                              mycontroller: _passwordController,
                              correction: false,
                              isPass: true,
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 70,
                          child: Center(
                            child: _isLoading?
                            const CircularProgressIndicator(
                              color: blueclr,
                            ):MyTextButtons(
                              name: 'Login', myOnPressed: loginUser),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                child: RichText(
                  text: TextSpan(
                      // style: TextStyle(color: Colors.grey[800]),
                      children: [
                        TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: blueclr)),
                        TextSpan(
                            text: 'SignUp',
                            style: TextStyle(color: orangeclr),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                navigateToSignUp();
                              })
                      ]),
                ),
              ),
            ],
          )),
        ));
  }
}
