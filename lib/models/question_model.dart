class Question {
  final int? id;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    this.id,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['question'],
      options: [
        map['first_answer'],
        map['second_answer'],
        map['third_answer'],
        map['fourth_answer'],
      ],
      correctAnswerIndex: map['correct_answer_index'],
    );
  }
}