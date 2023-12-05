import 'package:flutter/material.dart';
import 'package:second_project/data/question.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen(
      {super.key, required this.choosenAnswer, required this.timeAnswer});

  final List<String> choosenAnswer;
  final List<int> timeAnswer;

  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < choosenAnswer.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answer[0],
        'user_answer': choosenAnswer[i],
        'time_answer': timeAnswer[i]
      });
    }

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    final List<int> listWaktu = [];
    final summaryData = getSummaryData();
    final numCorrectQuestions = summaryData.where((data) {
      return data['user_answer'] == data['correct_answer'];
    });
    for (Map<String, Object> data in numCorrectQuestions) {
      int waktu = data['time_answer'] as int;
      listWaktu.add(waktu);
    }
    int sum = listWaktu.fold(0, (previous, current) => previous + current);
    final score = (numCorrectQuestions.length * 100) + (sum / 100);

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score : ${score.toInt()}'),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
