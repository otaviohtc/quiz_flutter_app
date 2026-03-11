import 'package:flutter/material.dart';
import 'wrong_answer.dart';
import 'finish.dart';
import 'question_data.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  late List<Question> _quizQuestions;

  @override
  void initState() {
    super.initState();
    _quizQuestions = List<Question>.from(allQuestions)..shuffle();
    _quizQuestions = _quizQuestions.take(10).toList();
  }

  void _submitAnswer(int selectedIndex) {
    if (selectedIndex == _quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
      if (_currentQuestionIndex < _quizQuestions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FinishScreen()),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WrongAnswerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _quizQuestions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        title: Text('Questão ${_currentQuestionIndex + 1} de ${_quizQuestions.length}'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQuestion.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            ...currentQuestion.options.asMap().entries.map((entry) {
              int index = entry.key;
              String optionText = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () => _submitAnswer(index),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text(optionText),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}