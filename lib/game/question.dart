import 'package:flutter/material.dart';
import 'wrong_answer.dart';
import 'finish.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';
import 'package:google_fonts/google_fonts.dart';

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

    List<Question> loaded = (data as List)
        .map((q) => Question.fromMap(q))
        .toList();

    loaded.shuffle();
    loaded = loaded.take(10).toList();

    setState(() {
      _quizQuestions = loaded;
      _loading = false;
    });
  }

  void _submitAnswer(int selectedIndex) {
    if (selectedIndex ==
        _quizQuestions[_currentQuestionIndex].correctAnswerIndex) {
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
    const primary = Color(0xFF0175C2);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_quizQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Nenhuma pergunta encontrada")),
      );
    }

    final currentQuestion = _quizQuestions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7FF),
      appBar: AppBar(
        title: Text(
          "Questão ${_currentQuestionIndex + 1} / ${_quizQuestions.length}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                blurRadius: 25,
                color: Colors.black12,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                currentQuestion.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              const SizedBox(height: 30),

              ...currentQuestion.options.asMap().entries.map((entry) {
                int index = entry.key;
                String optionText = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: InkWell(
                    onTap: () => _submitAnswer(index),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: primary.withOpacity(0.25)),
                        color: Colors.white,
                      ),
                      child: Text(
                        optionText,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
