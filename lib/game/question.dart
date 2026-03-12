import 'package:flutter/material.dart';
import 'wrong_answer.dart';
import 'finish.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';

class QuestionScreen extends StatefulWidget {
  final String difficulty;

  const QuestionScreen({super.key, required this.difficulty});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _quizQuestions = [];
  bool _loading = true;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
  final data = await supabase
      .from('questions')
      .select()
      .eq('difficulty', widget.difficulty);

  List<Question> loaded =
      (data as List).map((q) => Question.fromMap(q)).toList();

  loaded.shuffle();
  loaded = loaded.take(10).toList();

  setState(() {
    _quizQuestions = loaded;
    _loading = false;
  });
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
  if (_loading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  if (_quizQuestions.isEmpty) {
    return const Scaffold(
      body: Center(
        child: Text("Nenhuma pergunta encontrada :("),
      ),
    );
  }

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