import 'package:trivia/model/category.dart';
import 'package:trivia/model/section/section.dart';

final class JeopardySection implements Section {
  JeopardySection({
    required this.categories,
    required this.title,
    this.doubleCount = 1,
    this.value = 100
  });

  List<Category> categories;
  int value;
  int doubleCount;
  
  @override
  String title;
  
  @override
  final SectionType type = SectionType.jeopardy;
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'categories': categories,
      'value': value,
      'doubleCount': doubleCount
    };
  }

  factory JeopardySection.fromJson(Map<String, dynamic> json) {
    return JeopardySection(
      title: json['title'],
      categories: List<Category>.from((json['categories'] as List<dynamic>).map((e) => Category.fromJson(e))),
      doubleCount: json['doubleCount'],
      value: json['value']
    );
  }
}