import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/trivia.dart';

class TriviaEditorPage extends StatefulWidget {
  const TriviaEditorPage({
    super.key,
    required this.location,
    this.title = ''
  });

  final String location;
  final String title;

  @override
  State<TriviaEditorPage> createState() => _TriviaEditorPageState();
}

class _TriviaEditorPageState extends State<TriviaEditorPage> {

  late Trivia trivia;

  @override
  void initState() {
    super.initState();
    _readLocation();
  }

  void _readLocation() {
    if(widget.title != '') {
      trivia = Trivia(title: widget.title);
    }
    else {
      trivia = FileManager.readFile(widget.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}