import 'package:flutter/material.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/section.dart';
import 'package:trivia/pages/editor/jeopardy/jeopardy_section_editor.dart';

class SectionEditor extends StatefulWidget {
  const SectionEditor({
    required this.section,
    super.key
  });

  final Section section;

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {

  late Section section;
  @override
  void initState() {
    section = widget.section;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Section Editor - ${widget.section.title}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: switch (widget.section.type) {
                SectionType.jeopardy => JeopardySectionEditor(
                  section: widget.section as JeopardySection,
                  updater: _updateSection
                ),
                SectionType.bowl => const Placeholder()
              },
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: (){
                    Navigator.of(context).pop(widget.section);
                  },
                  child: const Text('Save and Return')
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  _updateSection(Section newSection) {
    setState(() {
      section = newSection;
    });
  }
}