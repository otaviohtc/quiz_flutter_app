import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/question_model.dart';
import 'question_update.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({super.key});

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  final supabase = Supabase.instance.client;

  List<Question> _questions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data = await supabase
        .from('questions')
        .select()
        .order('id');

    setState(() {
      _questions = (data as List).map((q) => Question.fromMap(q)).toList();
      _loading = false;
    });
  }

  Future<void> _deleteQuestion(int id) async {
    await supabase
        .from('questions')
        .delete()
        .eq('id', id);

    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gerenciar Perguntas"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuestionUpdateScreen(),
            ),
          );
          _loadQuestions();
        },
      ),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final q = _questions[index];

          return ListTile(
            title: Text(q.text),
            subtitle: Text("Resposta correta: ${q.correctAnswerIndex + 1}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuestionUpdateScreen(question: q),
                      ),
                    );
                    _loadQuestions();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteQuestion(q.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}