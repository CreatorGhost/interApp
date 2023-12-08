class Question {
  String text;
  String? answer;

  Question({required this.text, this.answer});

  // Named constructor for creating a Question from a string
  factory Question.fromString(String questionText) {
    return Question(text: questionText);
  }

  @override
  String toString() {
    return 'Question(text: $text, answer: $answer)';
  }
}