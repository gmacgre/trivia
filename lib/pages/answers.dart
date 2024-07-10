import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/logic/file_manager.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/model/trivia.dart';
import 'package:trivia/widgets/board.dart';

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
  Trivia _trivia = Trivia(title: 'DebugTitle');
  final List<List<bool>> _previouslySelected = [];
  late final QuestionBoardListener _listener;
  int _selectedCategory = -1;
  int _selectedQuestion = -1;
  
  


  @override
  void initState() {
    _trivia = FileManager.decode(widget.trivia);
    for(Category category in _trivia.categories) {
      List<bool> sets = [];
      for(int i = 0; i < category.questions.length; i++) {
        sets.add(false);
      }
      _previouslySelected.add(sets);
    }
    _listener = _AnswerQuestionBoardListener(parent: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _trivia.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Expanded(
            child: (_selectedCategory == -1 && _selectedQuestion == -1) ? _getBoardAndScores() : _getQuestionView()
          ),
        ],
      )
    );
  }

  Widget _getBoardAndScores() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: QuestionBoard(
              selected: _previouslySelected,
              trivia: _trivia,
              listener: _listener,
            )
          ),
        ),

        // TODO: BUILD SCORES
      ],
    );
  }

  Widget _getQuestionView() {
    Question question = _trivia.categories[_selectedCategory].questions[_selectedQuestion];
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              BaseEncoder.decode(question.answer),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _previouslySelected[_selectedCategory][_selectedQuestion] = true;
                  _selectedCategory = -1;
                  _selectedQuestion = -1;
                });
                DesktopMultiWindow.invokeMethod(0, 'board');
              },
              child: const Text('Return to Board')
            )
          ],
        ),
      ),
    );
  }


  void _setSelection(int category, int question) {
    setState(() {
      _selectedCategory = category;
      _selectedQuestion = question;
    });
    DesktopMultiWindow.invokeMethod(0, 'selection', {
      'category': category,
      'question': question
    });
  }
}

class _AnswerQuestionBoardListener implements QuestionBoardListener {
  final _AnswersPageState parent;
  const _AnswerQuestionBoardListener({
    required this.parent
  });

  @override
  void processTap(int category, int question) {
    parent._setSelection(category, question);
  }
}