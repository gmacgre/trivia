import 'package:trivia/model/question.dart';
import 'package:trivia/model/section/section.dart';

class FinalSection implements Section {

  FinalSection({
    required this.name,
    required this.title,
    required this.question
  });

  @override
  String title;

  @override
  SectionType type = SectionType.finalQuestion;

  Question question;
  String name;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'question': question,
      'name': name
    };
  }

  factory FinalSection.fromJson(Map<String, dynamic> json) {
    return FinalSection(
      title: json['title'],
      question: Question.fromJson(json['question']),
      name: json['name']
    );
  }
}