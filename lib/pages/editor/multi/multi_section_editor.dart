import 'package:flutter/material.dart';
import 'package:trivia/model/section/multianswer_section.dart';
import 'package:trivia/widgets/selector.dart';

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

  int selected = -1;
  String modifiedName = '';
  int newScore = 0;
  List<String> answers = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(
                  child: Selector(
                    contents: widget.section.questions.map((e) => e.question).toList(),
                    onSelection: (index) {
                      setState(() {
                        selected = index;
                        modifiedName = widget.section.questions[selected].question;
                        newScore = widget.section.questions[selected].value;
                        answers = widget.section.questions[selected].answers.map((e) => e).toList();
                      });
                    },
                    selected: selected
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            widget.section.questions.add(MultiAnswerQuestion(
                              value: 100,
                              question: "New Question", 
                              answers: []
                            ));
                          });
                        },
                        child: const Text('Add Question')
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: (selected == -1) ? null : () {
                          setState(() {
                            widget.section.questions.removeAt(selected);
                            selected = -1;
                          });
                        },
                        child: const Text('Delete')
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: (selected != -1) ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: TextEditingController()..text = modifiedName,
                    onChanged: (value) {
                      modifiedName = value;
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: answers.asMap().entries.map((e) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextField(
                              controller: TextEditingController()..text = e.value,
                              onChanged: (value) {
                                answers[e.key] = value;
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                answers.removeAt(e.key);
                              });
                            }, 
                            child: const Text('Delete')
                          )
                        ],
                      )).toList(),
                    ),
                  )
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      answers.add('New Answer');
                    });
                  }, child: const Text('Add Answer')
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Value: $newScore',
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
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.section.questions[selected].question = modifiedName;
                      widget.section.questions[selected].value = newScore;
                      widget.section.questions[selected].answers = answers;
                    });
                  },
                  child: const Text('Save Question Changes')
                )
              ],
            ) :
            Center(
              child: Text(
                'Select a Question To Edit',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _modifyValue(int change) {
    if(newScore + change < 0) {
      return;
    }
    setState(() {
      newScore += change;
    });
  }
}