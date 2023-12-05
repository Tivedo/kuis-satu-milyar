import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatelessWidget {
  const SplashScreen({required this.callback, super.key});
  final Function(String) callback;


  final Duration splashDuration = const Duration(seconds: 2);

  void navigateToMainScreen(BuildContext context) {
    callback('home-screen');
  }

  @override
  Widget build(BuildContext context) {
    Timer(splashDuration, () => navigateToMainScreen(context));
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash-screen.png', // Replace with the actual image path.
          fit: BoxFit.fill,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
