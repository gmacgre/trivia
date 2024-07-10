import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/widgets/board.dart';

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
  int _selectedQuestion = -1;
  final List<List<bool>> _previouslySelected = [];

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
      _processMessage(call.method, call.arguments);
    });
    for(Category category in widget.trivia.categories) {
      List<bool> sets = [];
      for(int i = 0; i < category.questions.length; i++) {
        sets.add(false);
      }
      _previouslySelected.add(sets);
    }
  }

  @override
  void dispose() {
    window.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showQuestion = _selectedCategory != -1 && _selectedQuestion != -1;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trivia.title),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: QuestionBoard(
                  selected: _previouslySelected,
                  trivia: widget.trivia,
                )
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: (showQuestion) ?  7.0 : 0.0
                    )
                  ),
                  duration: const Duration(milliseconds: 500),
                  width: (showQuestion) ? MediaQuery.of(context).size.width : 0.0,
                  height: (showQuestion) ? MediaQuery.of(context).size.height : 0.0,
                  child: Center(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SizedBox(
                        width: constraints.maxWidth * 0.6,
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 500),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: (showQuestion) ? 40.0 : 0.0
                          ),
                          child: Text(
                            (showQuestion) ? 
                              widget.trivia.categories[_selectedCategory].questions[_selectedQuestion].question : '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      )
    );
  }

  void _processMessage(String method, dynamic arguments) {
    // Just Blind access what we want, sadly no good way to typecheck
    switch (method) {
      case 'board': {
        setState(() {
          _previouslySelected[_selectedCategory][_selectedQuestion] = true;
          _selectedCategory = -1;
          _selectedQuestion = -1;
        });
      }
      case 'selection': {
        setState(() {
          _selectedCategory = arguments['category'];
          _selectedQuestion = arguments['question'];
        });
      }
    }
  }
}