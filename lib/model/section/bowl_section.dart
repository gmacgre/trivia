import 'package:trivia/model/question.dart';
import 'package:trivia/model/section/section.dart';

class BowlSection implements Section{

  BowlSection({
    required this.title,
    required this.questions
  });

  @override
  String title;

  @override
  final SectionType type = SectionType.bowl;

  List<Question> questions;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'questions': questions
    };
  }

  factory BowlSection.fromJson(Map<String, dynamic> json) {
    return BowlSection(
      title: json['title'],
      questions: List<Question>.from((json['questions'] as List<dynamic>).map((e) => Question.fromJson(e)))
    );
  }
}