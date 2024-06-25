class Trivia {
  String title;

  Trivia({
    required this.title
  });

  factory Trivia.fromJson(Map<String, dynamic> json) {
    return Trivia(
      title: json['title'],
      // Initialize other fields as needed.
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title
    };
  }
}
