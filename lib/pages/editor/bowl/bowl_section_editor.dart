import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/model/section/bowl_section.dart';
import 'package:trivia/pages/editor/question_editor.dart';

class BowlSectionEditor extends StatefulWidget {
  const BowlSectionEditor({
    required this.section,
    super.key
  });

  final BowlSection section;

  @override
  State<BowlSectionEditor> createState() => _BowlSectionEditorState();
}

class _BowlSectionEditorState extends State<BowlSectionEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: QuestionEditor(
            deleter: (idx) {
              setState(() {
                widget.section.questions.removeAt(idx);
              });
            },
            updater: (idx, value, type) {
              switch(type) {
                case 0: {
                  widget.section.questions[idx].question = value;
                }
                case 1: {
                  widget.section.questions[idx].answer = BaseEncoder.encode(value);
                }
                case 2: {
                  widget.section.questions[idx].imageLink = value;
                }
              }
            },
            questions: widget.section.questions,
          )
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              String newAnswer = BaseEncoder.encode('New Answer');
              widget.section.questions.add(Question(
                question: 'New Question',
                answer: newAnswer,
                imageLink: ''
              ));
            });
          }, 
          child: const Text('New Question')
        )
      ],
    );
  }
}