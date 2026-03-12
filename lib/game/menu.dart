import 'package:flutter/material.dart';
import 'question.dart';
import '../config/question_list.dart';
import 'package:google_fonts/google_fonts.dart';

enum Difficulty { easy, medium, hard }

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Difficulty _selectedDifficulty = Difficulty.easy;

  String difficultyToDb(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        return "EASY";
      case Difficulty.medium:
        return "MEDIUM";
      case Difficulty.hard:
        return "HARD";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz de Flutter/Dart',
              style: GoogleFonts.comicRelief(
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            const SizedBox(height: 30),

            const Text("Escolha a dificuldade", style: TextStyle(fontSize: 18)),

            const SizedBox(height: 10),

            RadioGroup<Difficulty>(
              groupValue: _selectedDifficulty,
              onChanged: (Difficulty? value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
              child: Column(
                children: const [
                  RadioListTile(title: Text("FÁCIL"), value: Difficulty.easy),
                  RadioListTile(title: Text("MÉDIO"), value: Difficulty.medium),
                  RadioListTile(title: Text("DIFÍCIL"), value: Difficulty.hard),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionScreen(
                      difficulty: difficultyToDb(_selectedDifficulty),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: const Text('Começar o Quiz'),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: const Text('Gerenciar perguntas'),
            ),
          ],
        ),
      ),
    );
  }
}
