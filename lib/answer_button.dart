import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton(
      {required this.answerText,
      required this.onTap,
      required this.btnAnswerImage,
      super.key});

  final String answerText;
  final void Function() onTap;
  final ImageProvider btnAnswerImage;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
          side: const BorderSide(color: Colors.transparent)),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: btnAnswerImage, // Replace with the actual image path.
            fit: BoxFit.cover, // Adjust the image fit as needed.
          ),
          borderRadius:
              BorderRadius.circular(8.0), // Set the same corner radius here.
        ),
        child: Container(
          width: 250, // Set your desired button width.
          height: 130, // Set your desired button height.
          alignment: Alignment.center,
          child: Text(
            answerText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
            ),
          ),
        ),
      ),
    );
  }
}
