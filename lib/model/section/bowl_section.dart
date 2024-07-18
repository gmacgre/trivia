import 'package:trivia/model/section/section.dart';

class BowlSection implements Section{

  BowlSection({
    required this.title
  });

  @override
  String title;

  @override
  final SectionType type = SectionType.bowl;

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name
    };
  }

  factory BowlSection.fromJson(Map<String, dynamic> json) {
    return BowlSection(
      title: json['title'],
    );
  }
}