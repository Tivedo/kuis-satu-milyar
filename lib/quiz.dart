import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:second_project/home_screen.dart';
import 'package:second_project/login_screen.dart';
import 'package:second_project/pin_screen.dart';
import 'package:second_project/question_screen.dart';
import 'package:second_project/register_screen2.dart';
import 'package:second_project/splash_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:second_project/winner_screen.dart';

import 'end_screen.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> selectedAnswers = [];
  List<int> timeAnswer = [];
  String activeScreen = 'splash-screen';
  String nama = '';
  int skor = 0;
  List<dynamic> finalScore = [];
  List<dynamic> answerData = [];
  int i = 0;
  String status = 'false';

  @override
  void initState() {
    super.initState();
    fetchAnswer().then((value) {
      setState(() {
        answerData = value; // Update the state with the fetched data
      });
    }).catchError((error) {
      // Handle any errors that occur during the API call
      print('Error fetching data: $error');
    });
  }

  void switchScreen(String newScreen) {
    setState(() {
      activeScreen = newScreen;
    });
  }

  void switchScreenRegist(String newScreen2) {
    setState(() {
      activeScreen = 'register-screen';
    });
  }

  void switchScreenLogin2(String newScreen2) {
    setState(() {
      activeScreen = 'login-screen';
    });
  }

  void switchScreenLogin(String username) {
    setState(() {
      activeScreen = 'pin-screen';
      nama = username;
    });
  }

  void switchScreenPin(String newScreen) {
    setState(() {
      activeScreen = newScreen;
    });
  }

  void switchScreenSoal(String newScreen) {
    setState(() {
      activeScreen = 'questions-screen';
    });
  }

  Future<List<dynamic>> fetchAnswer() async {
    const apiUrl =
        'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/get_soal';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void chooseAnswer(String answer, int time) async {
    if (answer == answerData[i]['jawaban']) {
      setState(() {
        skor += (100 + (time ~/ 100));
      });
    }
    if (i == 0) {
      skor.toInt();
      postScore(nama, skor);
    } else {
      skor.toInt();
      updateScore(nama, skor);
      // await http.put(
      //   Uri.parse(
      //       'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/update_skor?nama=$nama&skor=$skor'),
      //   headers: {'Content-Type': 'application/json'},
      // );
      // i++;
    }
    selectedAnswers.add(answer);
    if (selectedAnswers.length == 25) {
      Future<List<dynamic>> fetchUser() async {
        final response = await http.get(Uri.parse(
            'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/get_skor'));

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          throw Exception('Failed to load data');
        }
      }

      fetchUser().then((value) {
        setState(() {
          finalScore = value;
        });
        if (skor == finalScore[0]['nilai']) {
          setState(() {
            activeScreen = 'winner-screen';
          });
        } else {
          setState(() {
            activeScreen = 'end-screen';
          });
        }
        // createData(namaPemain, noHandphone);
      }).catchError((error) {});
    }
  }

  Future<void> postScore(String nama, int skor) async {
    final response = await http.post(
      Uri.parse(
          'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/insert_skor?nama=$nama&skor=$skor'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      i++;
    }
  }

  Future<void> updateScore(String nama, int skor) async {
    final response = await http.put(
      Uri.parse(
          'https://asia-south1.gcp.data.mongodb-api.com/app/tplb-prak5-kdhbq/endpoint/update_skor?nama=$nama&skor=$skor'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      i++;
    }
  }

  void checkRegistrationData() async {
    final prefs = await SharedPreferences.getInstance();
    final statusRegister = prefs.getString('status');
    setState(() {
      status = statusRegister.toString();
    });
  }

  @override
  Widget build(context) {
    Widget screenWidget = const Quiz();

    if (activeScreen == 'splash-screen') {
      screenWidget = SplashScreen(callback: switchScreen);
    }

    if (activeScreen == 'home-screen') {
      
      checkRegistrationData();
      if (status == 'true') {
        screenWidget = HomeScreen(callback: switchScreenLogin2);
      } else {
        screenWidget = HomeScreen(callback: switchScreenRegist);
      }
    }

    if (activeScreen == 'register-screen') {
      screenWidget = RegisterScreen2(callback: switchScreenLogin);
    }

    if (activeScreen == 'login-screen') {
      screenWidget = LoginScreen(callback: switchScreenLogin);
    }

    if (activeScreen == 'pin-screen') {
      screenWidget = PinScreen(callback: switchScreenSoal);
    }

    if (activeScreen == 'questions-screen') {
      screenWidget =
          QuestionScreen(onSelectAnswer: chooseAnswer, skor: skor, nama: nama);
    }

    if (activeScreen == 'winner-screen') {
      screenWidget = WinnerScreen(
        nama: nama,
        skor: skor.toString(),
      );
    }

    if (activeScreen == 'end-screen') {
      screenWidget = EndScreen(
        nama: nama,
        skor: skor.toString(),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background-question.png"),
                fit: BoxFit.cover),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}
