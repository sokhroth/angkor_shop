import 'dart:async';

import 'package:angkor_shop/views/authentication/second_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

//
class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 300), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SecondSplashScreen()),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset(
        'assets/images/ANGKORSHOP.png',
        height: 300,
        width: 300,
      ),
      splashIconSize: 200,
      nextScreen: SecondSplashScreen(),
      splashTransition: SplashTransition.scaleTransition,
      backgroundColor: Colors.white,
    );
  }
}
