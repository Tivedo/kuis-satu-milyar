import 'package:flutter/material.dart';
import 'package:second_project/component/join_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.callback, super.key});
  final Function(String) callback;

  void _navigateToRegister() {
    callback('register-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Image.asset(
            'assets/images/screen2.png', // Replace with the actual image path.
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              bottom: 30,
              left: 150,
              child: JoinButton(
                buttonText: 'Daftar',
                onPressed: _navigateToRegister,
              ))
        ],
      )),
    );
  }
}
