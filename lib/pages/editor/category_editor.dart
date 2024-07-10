import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/question.dart';

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
  CategoryType _type = CategoryType.rapid;
  final TextEditingController _controller = TextEditingController();
  List<Question> _questions = const [];
  @override
  void initState() {
    super.initState();
    _type = widget.category.type;
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

          // Category Type Selection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Category Type:',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: DropdownMenu<CategoryType>(
                    initialSelection: _type,
                    dropdownMenuEntries: CategoryType.values.map((e) => DropdownMenuEntry(value: e, label: e.toString())).toList(),
                    onSelected: (var selection) {
                      if(selection == null) return;
                      setState(() {
                        if(_type != selection) {
                          widget.category.questions = const [];
                        }
                        _type = selection;
                      });
                    },
                  )
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: _questions.asMap().entries.map((e) => Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController(text: _questions[e.key].question),
                          onChanged: (value) {
                            _questions[e.key].question = value;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController(text: BaseEncoder.decode(_questions[e.key].answer)),
                          onChanged: (value) {
                              _questions[e.key].answer = BaseEncoder.encode(value);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          _questions.removeAt(e.key);
                          setState(() {
                            _questions = _questions;
                          });
                        }, 
                        child: const Text('Delete')
                      ),
                    )
                  ],
                )).toList(),
              ),
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
                widget.category.type = _type;
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