import 'dart:async';

import 'package:angkor_shop/views/authentication/get_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SecondSplashScreen extends StatefulWidget {
  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GetStartedScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/ANGKORSHOP.png',height: 300,width: 300,),
      splashIconSize: 200,
      nextScreen: Container(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}