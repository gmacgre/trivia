import 'package:trivia/model/section/bowl_section.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/section.dart';

class Trivia {
  String title;
  List<Section> sections;

  Trivia({
    required this.title,
    required this.sections
  });

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      title: json['title'],
      sections: (json['sections'] as List).map(
        (e) => switch (e['type']) {
          "jeopardy" => JeopardySection.fromJson(e),
          "bowl" => BowlSection.fromJson(e),
          _ => JeopardySection(categories: [], title: "Error: Bad Section Read")
        }
      ).toList(),
      // Initialize other fields as needed.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sections': sections.map((e) => e.toJson()).toList()
    };
  }
}
