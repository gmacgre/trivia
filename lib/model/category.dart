import 'package:trivia/model/question.dart';

class Category {

  String title;
  CategoryType type;
  List<Question> questions;
  

  Category({
    required this.title,
    this.type = CategoryType.rapid,
    this.questions = const []
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      type: _categoryFromJson(json['type'] as String),
      questions: List<Question>.from((json['questions'] as List<dynamic>).map((e) => Question.fromJson(e)))
    );
  }

  static CategoryType _categoryFromJson(String src) {
    return switch(src) {
      'CategoryType.rapid' => CategoryType.rapid,
      'CategoryType.trueFalse' => CategoryType.trueFalse,
      'CategoryType.multiple' => CategoryType.multiple,
      'CategoryType.jeopardy' => CategoryType.jeopardy,
      _ => CategoryType.rapid
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.toString(),
      'questions': questions
    };
  }
}

enum CategoryType {
  rapid,
  trueFalse,
  multiple,
  jeopardy
}