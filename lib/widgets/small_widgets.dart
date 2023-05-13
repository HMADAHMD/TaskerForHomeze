import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homezetasker/utils/constants.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final TextInputType keyboaredType;
  final bool isPass;
  final TextEditingController mycontroller;
  final bool correction;

  const MyTextfield(
      {required this.hintText,
      required this.keyboaredType,
      this.isPass = false,
      required this.mycontroller,
      required this.correction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          errorBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: blueclr)),
          hintStyle: TextStyle(color: Colors.grey),
          hintText: hintText),
      keyboardType: keyboaredType,
      obscureText: isPass,
      controller: mycontroller,
      autocorrect: correction,
      cursorColor: orangeclr,
    );
  }
}

class MyTextButtons extends StatelessWidget {
  final myOnPressed;
  String name;
  MyTextButtons({required this.name, required this.myOnPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: myOnPressed,
      style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Ink(
          decoration: BoxDecoration(
              color: orangeclr, borderRadius: BorderRadius.circular(50)),
          child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              name,
              style: GoogleFonts.poppins(
                  fontSize: 30, color: blueclr, fontWeight: FontWeight.w500),
            ),
          )),
    );
  }
}

class ListItems extends StatelessWidget {
  final String listName;
  Icon listIcon;
  ListItems({required this.listName, required this.listIcon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: listIcon,
        iconColor: blueclr,
        title: Text(listName),
        tileColor: grayclr,
        trailing: Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
