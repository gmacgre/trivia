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
    trivia = Trivia(title: widget.title);
    if(FileManager.saveExists(widget.location)) {
      trivia = FileManager.readFile(widget.location);
    }
    else {
      FileManager.writeFile(trivia, widget.location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trivia.title),
        centerTitle: true,
      ),
      body: const Placeholder(),
    );
  }
}