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
    required this.scoreUpdater,
    required this.showBoard,
    required this.showQuestion,
    super.key
  });

  final JeopardySection section;
  final List<Player> players;
  final Function(int, int) scoreUpdater;
  final Function(int, int) showQuestion;
  final Function() showBoard;

  @override
  State<JeopardyAnswer> createState() => _JeopardyAnswerState();
}

class _JeopardyAnswerState extends State<JeopardyAnswer> {

  final List<List<bool>> _previouslySelected = [];
  late List<bool> _alreadyDeducted;
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
    _alreadyDeducted = widget.players.map((e) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_alreadyDeducted.length < widget.players.length) {
      while(_alreadyDeducted.length < widget.players.length) {
        _alreadyDeducted.add(false);
      }
    }
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
          value: widget.section.value,
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
                    widget.scoreUpdater(e.key, widget.players[e.key].score + (_selectedQuestion + 1) * widget.section.value);
                    _returnToBoard();
                  },
                  child: Text('${e.value.name} Correct')
                ),
                ElevatedButton(
                  onPressed: (_alreadyDeducted[e.key])? null : () {
                    widget.scoreUpdater(e.key, widget.players[e.key].score - (_selectedQuestion + 1) * widget.section.value);
                    _alreadyDeducted[e.key] = true;
                  },
                  child: Text('${e.value.name} Incorrect')
                ),
              ],
            )).toList(),
          ),
          ElevatedButton(
            onPressed: _returnToBoard,
            child: const Text('Return to Board')
          )
        ],
      ),
    );
  }

  void _returnToBoard() {
    widget.showBoard();
    setState(() {
      _alreadyDeducted = widget.players.map((e) => false).toList();
      _previouslySelected[_selectedCategory][_selectedQuestion] = true;
      _selectedCategory = -1;
      _selectedQuestion = -1;
    });
  }

  void _setSelection(int category, int question) {
    widget.showQuestion(category, question);
    setState(() {
      _selectedCategory = category;
      _selectedQuestion = question;
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