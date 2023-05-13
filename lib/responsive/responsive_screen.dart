import 'package:flutter/material.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/responsive/mobile_screen.dart';
import 'package:homezetasker/responsive/web_screen.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:provider/provider.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    TaskerProvider driverProvider = Provider.of(context, listen: false);
    await driverProvider.refreshTasker();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > dimensions) {
          return WebScreen();
        }
        return MobileScreen();
      },
    );
  }
}
