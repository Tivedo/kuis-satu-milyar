import 'package:flutter/material.dart';

class JoinButton extends StatelessWidget {
  const JoinButton({
    required this.buttonText,
    required this.onPressed,
    super.key
    });

  final String buttonText;
  final VoidCallback onPressed;

 @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero, // Remove padding around the image.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // Set button corner radius.
        ),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: const DecorationImage(
            image: AssetImage('assets/images/asset3.png'), // Replace with the actual image path.
            fit: BoxFit.cover, // Adjust the image fit as needed.
          ),
          borderRadius: BorderRadius.circular(8.0), // Set the same corner radius here.
        ),
        child: Container(
          width: 100, // Set your desired button width.
          height: 100, // Set your desired button height.
          alignment: Alignment.center,
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

