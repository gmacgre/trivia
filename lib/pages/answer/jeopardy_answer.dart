import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:trivia/logic/base_encoder.dart';
import 'package:trivia/model/category.dart';
import 'package:trivia/model/player.dart';
import 'package:trivia/model/question.dart';
import 'package:trivia/model/section/jeopardy_section.dart';
import 'package:trivia/widgets/board.dart';

class JeopardyAnswer extends StatefulWidget {
  const JeopardyAnswer({
    required this.section,
    required this.players,
    super.key
  });

  final JeopardySection section;
  final List<Player> players;

  @override
  State<JeopardyAnswer> createState() => _JeopardyAnswerState();
}

class _JeopardyAnswerState extends State<JeopardyAnswer> {

  final List<List<bool>> _previouslySelected = [];
  late final QuestionBoardListener _listener;
  int _selectedCategory = -1;
  int _selectedQuestion = -1;
  @override
  void initState() {
    // BUILDING SELECTION BOARD
    for(Category category in widget.section.categories) {
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.section.title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Expanded(
            child: (_selectedCategory == -1 && _selectedQuestion == -1) ? _getBoard() : _getQuestionView()
          ),
        ],
      );
  }

  Widget _getBoard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: JeopardyQuestionBoard(
          selected: _previouslySelected,
          listener: _listener, 
          section: widget.section,
        )
      ),
    );
  }

  Widget _getQuestionView() {
    Question question = widget.section.categories[_selectedCategory].questions[_selectedQuestion];
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              BaseEncoder.decode(question.answer),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.players.asMap().entries.map((e) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget.players[e.key].score += (_selectedQuestion + 1) * 100;
                      _updateScore(e.key, widget.players[e.key].score);
                      _returnToBoard();
                    },
                    child: Text('${e.value.name} Correct')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.players[e.key].score -= (_selectedQuestion + 1) * 100;
                      _updateScore(e.key, widget.players[e.key].score);
                    },
                    child: Text('${e.value.name} Incorrect')
                  ),
                ],
              )).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                DesktopMultiWindow.invokeMethod(0, 'buzz');
              },
              child: const Text('Buzzer')
            ),        
            ElevatedButton(
              onPressed: _returnToBoard,
              child: const Text('Return to Board')
            )
          ],
        ),
      ),
    );
  }

  void _updateScore(int idx, int score) {
    DesktopMultiWindow.invokeMethod(0, 'setScore', {
      'score': score,
      'index': idx
    });
  }

  void _returnToBoard() {
    setState(() {
      _previouslySelected[_selectedCategory][_selectedQuestion] = true;
      _selectedCategory = -1;
      _selectedQuestion = -1;
    });
    DesktopMultiWindow.invokeMethod(0, 'board');
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
  final _JeopardyAnswerState parent;
  const _AnswerQuestionBoardListener({
    required this.parent
  });

  @override
  void processTap(int category, int question) {
    parent._setSelection(category, question);
  }
}