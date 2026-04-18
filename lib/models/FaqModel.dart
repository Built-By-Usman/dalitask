class FaqModel {
  final int id;
  final String question;
  final String answer;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
    );
  }
}