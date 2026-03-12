import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';

class QuestionUpdateScreen extends StatefulWidget {
  final Question? question;

  const QuestionUpdateScreen({super.key, this.question});

  @override
  State<QuestionUpdateScreen> createState() => _QuestionUpdateScreenState();
}

class _QuestionUpdateScreenState extends State<QuestionUpdateScreen> {
  final supabase = Supabase.instance.client;

  final _questionController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _answer3Controller = TextEditingController();
  final _answer4Controller = TextEditingController();

  int _correctAnswerIndex = 0;
  String _difficulty = "EASY";

  bool get isEditing => widget.question != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final q = widget.question!;

      _questionController.text = q.text;
      _answer1Controller.text = q.options[0];
      _answer2Controller.text = q.options[1];
      _answer3Controller.text = q.options[2];
      _answer4Controller.text = q.options[3];

      _correctAnswerIndex = q.correctAnswerIndex;
    }
  }

  Future<void> _saveQuestion() async {
    final data = {
      "question": _questionController.text,
      "first_answer": _answer1Controller.text,
      "second_answer": _answer2Controller.text,
      "third_answer": _answer3Controller.text,
      "fourth_answer": _answer4Controller.text,
      "correct_answer_index": _correctAnswerIndex,
      "difficulty": _difficulty,
    };

    if (isEditing) {
      await supabase
          .from("questions")
          .update(data)
          .eq("id", widget.question!.id!);
    } else {
      await supabase.from("questions").insert(data);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _answerField(TextEditingController controller, int index) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Resposta ${index + 1}"),
          ),
        ),
        Radio<int>(value: index),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Editar Pergunta" : "Nova Pergunta"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(labelText: "Pergunta"),
            ),

            const SizedBox(height: 20),

            RadioGroup<int>(
              groupValue: _correctAnswerIndex,
              onChanged: (int? value) {
                setState(() {
                  _correctAnswerIndex = value!;
                });
              },
              child: Column(
                children: [
                  _answerField(_answer1Controller, 0),
                  _answerField(_answer2Controller, 1),
                  _answerField(_answer3Controller, 2),
                  _answerField(_answer4Controller, 3),
                ],
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: _difficulty,
              items: const [
                DropdownMenuItem(value: "EASY", child: Text("EASY")),
                DropdownMenuItem(value: "MEDIUM", child: Text("MEDIUM")),
                DropdownMenuItem(value: "HARD", child: Text("HARD")),
              ],
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Dificuldade"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _saveQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
