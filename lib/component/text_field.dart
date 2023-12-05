import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const InputText({required this.controller, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/text_field.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white,fontSize: 24),
      ),
    );
  }
}