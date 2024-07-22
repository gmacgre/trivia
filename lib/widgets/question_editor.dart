import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/question.dart';

class QuestionEditor extends StatelessWidget {
  const QuestionEditor({
    required this.questions,
    required this.updater,
    required this.deleter,
    super.key
  });

  final List<Question> questions;

  final Function(int, String, int) updater;
  final Function(int) deleter;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: questions.asMap().entries.map((e) => Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: TextEditingController(text: questions[e.key].question),
                  onChanged: (value) {
                    updater(e.key, value, 0);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: TextEditingController(text: BaseEncoder.decode(questions[e.key].answer)),
                  onChanged: (value) {
                    updater(e.key, value, 1);
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Image Link'
                  ),
                  controller: TextEditingController(text: questions[e.key].imageLink),
                  onChanged: (value) {
                    updater(e.key, value, 2);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  deleter(e.key);
                }, 
                child: const Text('Delete')
              ),
            )
          ],
        )).toList(),
      ),
    );
  }
}