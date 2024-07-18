import 'package:trivia/model/category.dart';
import 'package:trivia/model/section/section.dart';

final class JeopardySection implements Section {
  JeopardySection({
    required this.categories,
    required this.title,
  });

  List<Category> categories;
  
  @override
  String title;
  
  @override
  final SectionType type = SectionType.jeopardy;
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type.name,
      'categories': categories
    };
  }

  factory JeopardySection.fromJson(Map<String, dynamic> json) {
    return JeopardySection(
      title: json['title'],
      categories: List<Category>.from((json['categories'] as List<dynamic>).map((e) => Category.fromJson(e)))
    );
  }
}