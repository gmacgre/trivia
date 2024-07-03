class Question {
  const Question();

  Map<String, dynamic> toJson() {
    return {};
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return const Question();
  }
}