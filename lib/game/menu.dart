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
    final primary = const Color(0xFF0175C2); // Dart blue

    return Scaffold(
      backgroundColor: const Color(0xFFEFF7FF),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
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
            children: [
              Text(
                "Quiz Flutter/Dart",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Escolha a dificuldade",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 20),

              RadioGroup<Difficulty>(
                groupValue: _selectedDifficulty,
                onChanged: (Difficulty? value) {
                  setState(() {
                    _selectedDifficulty = value!;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Column(
                      children: [
                        Radio(value: Difficulty.easy),
                        Text("FÁCIL"),
                      ],
                    ),
                    Column(
                      children: [
                        Radio(value: Difficulty.medium),
                        Text("MÉDIO"),
                      ],
                    ),
                    Column(
                      children: [
                        Radio(value: Difficulty.hard),
                        Text("DIFÍCIL"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Começar o Quiz",
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuestionListScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Gerenciar perguntas",
                    style: GoogleFonts.poppins(
                      color: primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
