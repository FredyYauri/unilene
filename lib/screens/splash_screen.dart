import 'dart:async';
import 'package:flutter/material.dart';
import 'package:unilene_app/screens/login_screen.dart';
import 'package:unilene_app/util/color_constant.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.primaryColor,
      body: Center(
        child: Image.asset(
          'assets/images/screensplash.png',
          scale: 2.0,
        ),
      ),
    );
  }
}
