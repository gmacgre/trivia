import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/section/section.dart';

class MultiAnswerSection implements Section {
  @override
  String title;
  @override
  final SectionType type = SectionType.multi;

  List<MultiAnswerQuestion> questions;
  int questionValue;

  MultiAnswerSection({
    required this.title,
    required this.questions,
    required this.questionValue
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'questions': questions,
      'value': questionValue
    };
  }

  factory MultiAnswerSection.fromJson(Map<String, dynamic> json) {
    return MultiAnswerSection(
      questionValue: json['value'],
      title: json['title'],
      questions: List<MultiAnswerQuestion>.from((json['questions'] as List<dynamic>).map((e) => MultiAnswerQuestion.fromJson(e))),
    );
  }
}

class MultiAnswerQuestion {
  String question;
  List<String> answers;

  MultiAnswerQuestion({
    required this.question,
    required this.answers
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': List<String>.from(answers.map((e) => BaseEncoder.encode(e))).toList(),
    };
  }

  factory MultiAnswerQuestion.fromJson(Map<String, dynamic> json) {
    return MultiAnswerQuestion(
      question: json['question'], 
      answers: List<String>.from((json['answers'] as List<String>).map((e) => BaseEncoder.decode(e)))
    );
  }
}