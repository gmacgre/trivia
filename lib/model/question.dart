class Question {
  String question;
  String answer;
  String imageLink;
  Question({
    required this.question,
    required this.answer,
    required this.imageLink
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'imageLink': imageLink,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer: json['answer'],
      imageLink: json['imageLink']
      );
  }
}