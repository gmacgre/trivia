import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/section/final_section.dart';

class FinalSectionEditor extends StatefulWidget {
  const FinalSectionEditor({
    super.key,
    required this.section,
  });

  final FinalSection section;

  @override
  State<FinalSectionEditor> createState() => _FinalSectionEditorState();
}

class _FinalSectionEditorState extends State<FinalSectionEditor> {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    nameController.text = widget.section.name;
    TextEditingController questionController = TextEditingController();
    questionController.text = widget.section.question.question;
    TextEditingController answerController = TextEditingController();
    answerController.text = BaseEncoder.decode(widget.section.question.answer);
    return SafeArea(
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Category:'),
                  ),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      onChanged: (value) {
                        widget.section.name = nameController.text;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Question:'),
                  ),
                  Expanded(
                    child: TextField(
                      controller: questionController,
                      onChanged: (value) {
                        widget.section.question.question = questionController.text;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Answer:'),
                  ),
                  Expanded(
                    child: TextField(
                      controller: answerController,
                      onChanged: (value) {
                        widget.section.question.answer = BaseEncoder.encode(answerController.text);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}