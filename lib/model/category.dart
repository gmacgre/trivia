import 'package:trivia/model/question.dart';

class Category {

  String title;
  List<Question> questions;
  

  Category({
    required this.title,
    this.questions = const []
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      questions: List<Question>.from((json['questions'] as List<dynamic>).map((e) => Question.fromJson(e)))
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'questions': questions
    };
  }
}