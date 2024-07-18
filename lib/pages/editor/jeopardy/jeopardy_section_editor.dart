import 'package:flutter/material.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/model/section/section.dart';
import 'package:trivia/pages/editor/category_editor.dart';
import 'package:trivia/pages/editor/selector.dart';

class JeopardySectionEditor extends StatefulWidget {
  const JeopardySectionEditor({
    required this.section,
    required this.updater,
    super.key
  });

  final JeopardySection section;
  final Function(Section) updater;

  @override
  State<JeopardySectionEditor> createState() => _JeopardySectionEditorState();
}

class _JeopardySectionEditorState extends State<JeopardySectionEditor> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Select a Category to Edit',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Selector(
              contents: widget.section.categories.map((e) => e.title).toList(),
              onSelection: (int newIndex) {
                setState(() {
                  selected = newIndex;
                });
              },
              selected: selected
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.section.categories.add(Category(title: 'New Category', questions: []));
                    });
                  }, 
                  child: const Text('Add New Category')
                ),
                ElevatedButton(
                  onPressed: (selected == -1) ? null : () async {
                    Category? newData = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CategoryEditor(category: widget.section.categories[selected]),
                      )
                    );
                    setState(() {
                      widget.section.categories[selected] = (newData != null) ? newData : widget.section.categories[selected];
                      selected = -1;
                    });
                  }, 
                  child: const Text('Edit')
                ),
                ElevatedButton(
                  onPressed: (selected == -1) ? null : () {
                    setState(() {
                      widget.section.categories.removeAt(selected);
                      selected = -1;
                    });
                  }, 
                  child: const Text('Delete')
                ),
              ],
            )
          ),
        ),
      ],
    );
  }
}