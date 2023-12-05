import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'component/score.dart';

class WinnerScreen extends StatelessWidget {
  const WinnerScreen({required this.nama,required this.skor,super.key});
  final String nama;
  final String skor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Image.asset(
            'assets/images/background-winner.png', // Replace with the actual image path.
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Text(
                nama,
                style: GoogleFonts.roboto(
                    color: Colors.blue, fontSize: 24, fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score:',
                    style: GoogleFonts.roboto(
                        color: Colors.red,
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Score(
                      answerText: skor,
                      onTap: () {},
                      btnAnswerImage: const AssetImage('assets/images/score.png'))
                ],
              ),
            ],
          ),
        ],
      )),
    );
  }
}
