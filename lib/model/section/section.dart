abstract class Section {
  Section({
    required this.title,
    required this.type
  });

  SectionType type;
  String title;

  Map<String, dynamic> toJson();
}


enum SectionType {
  jeopardy,
  bowl,
}