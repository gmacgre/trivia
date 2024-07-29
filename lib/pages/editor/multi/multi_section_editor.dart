import 'package:flutter/material.dart';
import 'package:trivia/model/section/multianswer_section.dart';

class MultiAnswerSectionEditor extends StatefulWidget {
  const MultiAnswerSectionEditor({
    super.key,
    required this.section
  });

  final MultiAnswerSection section;

  @override
  State<MultiAnswerSectionEditor> createState() => _MultiAnswerSectionEditorState();
}

class _MultiAnswerSectionEditorState extends State<MultiAnswerSectionEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor, width: 5)),
            width: MediaQuery.of(context).size.width * 0.6,
            child: SingleChildScrollView(
              child: Column(
                children: widget.section.questions.asMap().entries.map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 3, 
                      child: Text(
                        e.value.question,
                        textAlign: TextAlign.center,
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                        
                          },
                          child: const Text('Edit')
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              widget.section.questions.removeAt(e.key);
                            });
                          },
                          child: const Text('Delete')
                        ),
                      ),
                    )
                  ],
                )).toList(),
              ),
            ),
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Value: ${widget.section.questionValue}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  _modifyValue(100);
                },
                icon: const Icon(Icons.add)
              ),
            ),
            IconButton(
              onPressed: () {
                _modifyValue(-100);
              },
              icon: const Icon(Icons.remove)
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                widget.section.questions.add(MultiAnswerQuestion(
                  question: "New Question", 
                  answers: []
                ));
              });
            },
            child: const Text('Add Question')
          ),
        )
      ],
    );
  }

  void _modifyValue(int change) {
    if(widget.section.questionValue + change < 0) {
      return;
    }
    setState(() {
      widget.section.questionValue += change;
    });
  }
}