import 'package:trivia/model/category.dart';

class Trivia {
  String title;
  List<Category> categories;

  Trivia({
    required this.title,
    this.categories = const []
  });

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      title: json['title'],
      categories: List<Category>.from((json['categories'] as List<dynamic>).map((e) => Category.fromJson(e)))
      // Initialize other fields as needed.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'categories': categories
    };
  }
}
