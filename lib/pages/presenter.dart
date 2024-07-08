import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/trivia.dart';

class PresenterPage extends StatefulWidget {
  const PresenterPage({
    required this.trivia,
    super.key
  });

  final Trivia trivia;

  @override
  State<PresenterPage> createState() => _PresenterPageState();
}

class _PresenterPageState extends State<PresenterPage> {
  late final WindowController window;
  int _selectedCategory = -1;

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.createWindow(FileManager.encode(widget.trivia)).then((value) => setState((){
      window = value;
      window 
      ..setFrame(const Offset(0, 0) & const Size(1280, 720))
      ..center()
      ..setTitle('Controller Window')
      ..show();
    }));
    DesktopMultiWindow.setMethodHandler((call, fromWindowId) async {
      debugPrint('${call.method}, ${call.arguments}');
      switch(call.method) {
        case 'category': {
          setState(() {
            _selectedCategory = int.parse(call.arguments as String);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    window.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trivia.title),
        centerTitle: true,
      ),
      body: (_selectedCategory >= 0 && _selectedCategory < widget.trivia.categories.length) ? Text('Selected Category is: ${widget.trivia.categories[_selectedCategory]}') : const Text('No Category Selected')
    );
  }
}