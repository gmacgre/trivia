import 'package:flutter/material.dart';
import 'package:trivia/model/section/bowl_section.dart';
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

  final TextEditingController _controller = TextEditingController();
  late Section section;
  @override
  void initState() {
    section = widget.section;
    _controller.text = section.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(section.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Section Title:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) => {section.title = value},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MenuBar(
                      children: [ 
                        SubmenuButton(
                          menuChildren: SectionType.values.map((e) => MenuItemButton(
                            onPressed: () {
                              if(e == section.type) return;
                              _resetSection(e);
                            },
                            child: Text(e.name)
                          )).toList(),
                          child: Text(section.type.name),
                        )
                      ]
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 7,
              child: switch (section.type) {
                SectionType.jeopardy => JeopardySectionEditor(
                  section: section as JeopardySection,
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
                    Navigator.of(context).pop(section);
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
  
  void _resetSection(SectionType e) {
    setState(() {
      section = switch(e) {
        SectionType.jeopardy => JeopardySection(categories: [], title: section.title),
        SectionType.bowl => BowlSection(title: section.title)
      };
    });
  }
}