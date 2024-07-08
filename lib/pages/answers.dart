import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/trivia.dart';

class AnswersPage extends StatefulWidget {
  final String trivia;
  const AnswersPage({
    super.key,
    required this.trivia
  });

  @override
  State<AnswersPage> createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  Trivia _trivia = Trivia(title: 'title');
  int _selectedCategory = -1;
  int _selectedQuestion = -1;

  @override
  void initState() {
    _trivia = FileManager.decode(widget.trivia);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    List<Widget> categoryButtons = [];
    categoryButtons.add(Text(_trivia.title));
    categoryButtons.add(Text('Selected Category: $_selectedCategory'));
    categoryButtons.add(Text('Selected Question: $_selectedQuestion'));
    
    categoryButtons.addAll(_trivia.categories.asMap().entries.map((e) => ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedCategory = e.key;
        });
        // 0 is Main Window's Id
        DesktopMultiWindow.invokeMethod(0, 'category', '$_selectedCategory');
      },
      child: Text(e.value.title))
    ).toList());
    
    
    return Scaffold(
      appBar: AppBar(title: const Text('Answers')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: categoryButtons,
      )
    );
  }
}