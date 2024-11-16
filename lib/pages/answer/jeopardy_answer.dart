import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trivia/logic/base_encoder.dart';
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
    required this.showDailyDouble,
    super.key
  });

  final JeopardySection section;
  final List<Player> players;
  final Function(int, int) scoreUpdater;
  final Function(int, int) showQuestion;
  final Function() showBoard;
  final Function() showDailyDouble;

  @override
  State<JeopardyAnswer> createState() => _JeopardyAnswerState();
}

class _JeopardyAnswerState extends State<JeopardyAnswer> {

  final List<List<bool>> _previouslySelected = [];
  late List<bool> _alreadyDeducted;
  late Set<List<int>> _dailyDoubles;
  late final QuestionBoardListener _listener;

  Question? toShow;

  bool _isDouble = false;
  bool _doubleClue = false;
  int _selectedCategory = -1;
  String wager = '0';
  int _selectedQuestion = -1;

  @override
  void initState() {
    super.initState();
    // BUILDING SELECTION BOARD
    for (var element in widget.section.categories) { 
      _previouslySelected.add(element.questions.map((e) => false).toList());
    }
    _listener = _AnswerQuestionBoardListener(parent: this);
    _alreadyDeducted = widget.players.map((e) => false).toList();
    _dailyDoubles = {};
    Random rng = Random();
    while(_dailyDoubles.length < (widget.section.value) / 200) {
      // Make new Daily Double Section
      _dailyDoubles.add([rng.nextInt(widget.section.categories.length), rng.nextInt(widget.section.categories[0].questions.length)]);
    }
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
          child: (toShow == null) ? _getBoard() : _getQuestionView()
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
          dailyDoubles: _dailyDoubles
        )
      ),
    );
  }

  Widget _getQuestionView() {

    if(toShow == null) {
      return const Placeholder();
    }
    Question question = toShow!;
    TextEditingController wagerController = TextEditingController()..text = wager;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            BaseEncoder.decode(question.answer),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          (_isDouble) ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Max Wager: ${widget.section.value * 5} or Player Score',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: wagerController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    wager = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: (_doubleClue) ? null : () {
                    widget.showQuestion(_selectedCategory, _selectedQuestion);
                    setState(() {
                      _doubleClue = true;
                    });
                  }, 
                  child: const Text('Reveal Clue')
                ),
              ),
            ],
          ) : const SizedBox(width: 0, height: 0,),
          Wrap(
            alignment: WrapAlignment.center,
            children: widget.players.asMap().entries.map((e) => SizedBox(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(e.value.name, style: Theme.of(context).textTheme.labelMedium,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (_isDouble && !_doubleClue) ? null :  () {
                          if(wagerController.text == '') wagerController.text = '0';
                          int newScore = (_isDouble) ? int.parse(wagerController.text) : (_selectedQuestion + 1) * widget.section.value;
                          widget.scoreUpdater(e.key, widget.players[e.key].score + newScore);
                          _returnToBoard();
                        },
                        icon: const Icon(Icons.add_circle, size: 30)
                      ),
                      IconButton(
                        onPressed: ((_isDouble && !_doubleClue) || _alreadyDeducted[e.key]) ? null : () {
                          if(wagerController.text == '') wagerController.text = '0';
                          int newScore = (_isDouble) ? int.parse(wagerController.text) : (_selectedQuestion + 1) * widget.section.value;
                          widget.scoreUpdater(e.key, widget.players[e.key].score - newScore);
                          (_isDouble) ? _returnToBoard() : setState(() {
                            _alreadyDeducted[e.key] = true;
                          });
                        },
                        icon: const Icon(Icons.remove_circle, size: 30)
                      ),
                    ],
                  )
                ],
              ),
            )).toList(),
          ),
          ElevatedButton(
            onPressed: (_isDouble && !_doubleClue) ? null : () {
              _returnToBoard();
            },
            child: const Text('Return to Board')
          )
        ],
      ),
    );
  }
  
  void _returnToBoard() {
    widget.showBoard();
    setState(() {
      toShow = null;
      wager = '0';
      _isDouble = false;
      _doubleClue = false;
      _alreadyDeducted = widget.players.map((e) => false).toList();
      _previouslySelected[_selectedCategory][_selectedQuestion] = true;
      _selectedCategory = -1;
      _selectedQuestion = -1;
    });
  }

  void _setSelection(int category, int question) {
    (_isDailyDouble(category, question)) ? widget.showDailyDouble() : widget.showQuestion(category, question);
    setState(() {
        _selectedCategory = category;
        _selectedQuestion = question;
        toShow = widget.section.categories[_selectedCategory].questions[_selectedQuestion];
        _isDouble = _isDailyDouble(category, question);
    });
  }

  bool _isDailyDouble(int x, int y) {
    var check  = _dailyDoubles.toList();
    for(var pair in check) {
      if(pair[0] == x && pair[1] == y) {
        return true;
      }
    }
    return false;
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