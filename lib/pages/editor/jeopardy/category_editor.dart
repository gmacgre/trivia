import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/pages/editor/question_editor.dart';

class CategoryEditor extends StatefulWidget {
  final Category category;

  const CategoryEditor({
    super.key,
    required this.category
  });

  @override
  State<CategoryEditor> createState() => _CategoryEditorState();
}

class _CategoryEditorState extends State<CategoryEditor> {
  final TextEditingController _controller = TextEditingController();
  List<Question> _questions = const [];
  @override
  void initState() {
    super.initState();
    _controller.text = widget.category.title;
    _questions = widget.category.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.title),
        centerTitle: true,
      ),
      body: Column(
        children: [

          // Title Editing
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Title:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: _controller,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: QuestionEditor(
              questions: _questions,
              updater: (idx, value, type) {
                switch(type) {
                  case 0: {
                    _questions[idx].question = value;
                  }
                  case 1: {
                    _questions[idx].answer = BaseEncoder.encode(value);
                  }
                  case 2: {
                    _questions[idx].imageLink = value;
                  }
                }
              },
              deleter: (idx) {
                _questions.removeAt(idx);
                setState(() {
                  _questions = _questions;
                });
              },
            )
          ),

          // Add Question Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: (){
                String newAnswer = BaseEncoder.encode('New Answer');
                _questions.add(Question(question: 'New Question', answer: newAnswer, imageLink: ''));
                setState(() {
                  _questions = _questions;
                });
              },
              child: const Text('Add Question')
            ),
          ),

          // Save and Return
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
              onPressed: (){
                widget.category.title = _controller.text;
                Navigator.of(context).pop(widget.category);
              },
              child: const Text('Save and Return')
            ),
          )
        ]
      ),
    );
  }
}