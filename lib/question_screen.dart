import 'dart:async';

import 'package:flutter/material.dart';
import 'package:second_project/answer_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'component/score.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen(
      {super.key,
      required this.onSelectAnswer,
      required this.skor,
      required this.nama});

  final void Function(String answer, int time) onSelectAnswer;
  final int skor;
  final String nama;

  @override
  State<QuestionScreen> createState() {
    return _QuestionScreenState();
  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  var currentQuestionIndex = 0;
  bool isButtonVisible = true;
  bool isButtonDisabled = false;
  bool isButton1Visible = true;
  bool isButton2Visible = true;
  bool isButton3Visible = true;
  bool isButton4Visible = true;
  int _milliseconds = 10000;
  Timer? timer;
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('wss://immediate-sugared-park.glitch.me');

  @override
  void initState() {
    super.initState();
    startTimer();
    channel.stream.listen((message) {
      setState(() {
            _milliseconds = 10000;
            isButton1Visible = true;
            isButton2Visible = true;
            isButton3Visible = true;
            isButton4Visible = true;
            isButtonDisabled = false;
          });
    });
  }

  answerQuestion1(String selectedAnswer, int time) {
    widget.onSelectAnswer(selectedAnswer, time);
    setState(() {
      isButton2Visible = false;
      isButton3Visible = false;
      isButton4Visible = false;
      isButtonDisabled = true;
    });
  }

  answerQuestion2(String selectedAnswer, int time) {
    widget.onSelectAnswer(selectedAnswer, time);
    setState(() {
      isButton1Visible = false;
      isButton3Visible = false;
      isButton4Visible = false;
      isButtonDisabled = true;
    });
  }

  answerQuestion3(String selectedAnswer, int time) {
    widget.onSelectAnswer(selectedAnswer, time);
    setState(() {
      isButton1Visible = false;
      isButton2Visible = false;
      isButton4Visible = false;
      isButtonDisabled = true;
    });
  }

  answerQuestion4(String selectedAnswer, int time) {
    widget.onSelectAnswer(selectedAnswer, time);
    setState(() {
      isButton1Visible = false;
      isButton2Visible = false;
      isButton3Visible = false;
      isButtonDisabled = true;
    });
  }

  void fetchSoal() async {
    final response = await http.get(Uri.parse(
        'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/get_pin'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data[0]['status'] == 'start') {
        if (mounted) {
          setState(() {
            _milliseconds = 10000;
            isButton1Visible = true;
            isButton2Visible = true;
            isButton3Visible = true;
            isButton4Visible = true;
            isButtonDisabled = false;
          });
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          _milliseconds -= 100;
        });
      }
    });
  }

  String formatTime(int milliseconds) {
    int minutes = (milliseconds ~/ 60000) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    // int remainingMilliseconds = milliseconds % 1000;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    channel.sink.close(); // Tutup koneksi saat widget dihapus
    super.dispose();
  }

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 250,
            ),
            // Text(formatTime(_milliseconds)),z
            Text(
              widget.nama,
              style: GoogleFonts.roboto(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
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
                    answerText: widget.skor.toString(),
                    onTap: () {},
                    btnAnswerImage: const AssetImage('assets/images/score.png'))
              ],
            ),
            GridView.count(shrinkWrap: true, crossAxisCount: 2, children: [
              Visibility(
                  visible: isButton1Visible,
                  child: AnswerButton(
                      answerText: 'A',
                      btnAnswerImage:
                          const AssetImage('assets/images/btn-a.png'),
                      onTap: () {
                        isButtonDisabled
                            ? null
                            : answerQuestion1('A', _milliseconds);
                      })),
              Visibility(
                  visible: isButton2Visible,
                  child: AnswerButton(
                      answerText: 'B',
                      btnAnswerImage:
                          const AssetImage('assets/images/btn-b.png'),
                      onTap: () {
                        isButtonDisabled
                            ? null
                            : answerQuestion2('B', _milliseconds);
                      })),
              Visibility(
                  visible: isButton3Visible,
                  child: AnswerButton(
                      answerText: 'C',
                      btnAnswerImage:
                          const AssetImage('assets/images/btn-c.png'),
                      onTap: () {
                        isButtonDisabled
                            ? null
                            : answerQuestion3('C', _milliseconds);
                      })),
              Visibility(
                visible: isButton4Visible,
                child: AnswerButton(
                    answerText: 'D',
                    btnAnswerImage: const AssetImage('assets/images/btn-d.png'),
                    onTap: () {
                      isButtonDisabled
                          ? null
                          : answerQuestion4('D', _milliseconds);
                    }),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
