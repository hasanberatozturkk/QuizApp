class Question {
  final int? id;
  final int? categoryId;
  final String question;
  final String correctAnswer;
  final String options;

  Question({
    this.id,
    required this.categoryId,
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  // burası veritabanına yazılırken kullanılır.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'question': question,
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }

  // burası veritabanından okunduğunda kullanılır.
  factory Question.fromMap(Map<String, dynamic> map) => Question(
    id: map['id'],
    categoryId: map['categoryId'],
    question: map['question'],
    correctAnswer: map['correctAnswer'],
    options: map['options'],
  );
}
