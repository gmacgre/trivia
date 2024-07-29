import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/section/section.dart';

class MultiAnswerSection implements Section {
  @override
  String title;
  @override
  final SectionType type = SectionType.multi;

  List<MultiAnswerQuestion> questions;

  MultiAnswerSection({
    required this.title,
    required this.questions,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'questions': questions
    };
  }

  factory MultiAnswerSection.fromJson(Map<String, dynamic> json) {
    return MultiAnswerSection(
      title: json['title'],
      questions: List<MultiAnswerQuestion>.from((json['questions'] as List<dynamic>).map((e) => MultiAnswerQuestion.fromJson(e))),
    );
  }
}

class MultiAnswerQuestion {
  String question;
  List<String> answers;
  int value;

  MultiAnswerQuestion({
    required this.question,
    required this.answers,
    required this.value
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'question': question,
      'answers': List<String>.from(answers.map((e) => BaseEncoder.encode(e))).toList(),
    };
  }

  factory MultiAnswerQuestion.fromJson(Map<String, dynamic> json) {
    return MultiAnswerQuestion(
      value: json['value'],
      question: json['question'], 
      answers: List<String>.from((json['answers'] as List <dynamic>).map((e) => BaseEncoder.decode(e as String)))
    );
  }
}