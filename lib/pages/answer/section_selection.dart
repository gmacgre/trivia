import 'package:flutter/material.dart';
import 'package:trivia/model/section/section.dart';

class SectionSelection extends StatelessWidget {
  const SectionSelection({
    required this.sections,
    required this.launcher,
    super.key
  });

  final List<Section> sections;
  final Function(int) launcher;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      children: sections.asMap().entries.map((e) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            launcher(e.key);
          },
          child: Text(e.value.title)
        ),
      )).toList()
    );
  }
}